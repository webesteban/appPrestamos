# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  helper_method :frame_id_for, :user_list_locals_for, :keep_params_for

  def index
    @q = User.includes(:status, :role, :city).ransack(params[:q])
    @pagy, @users = pagy(@q.result, items: 1)

    respond_to do |format|
      format.html
      format.turbo_stream { render :index } # o render turbo_frame si tenés
    end
  end

  def new
    @hierarchy_level = params[:hierarchy_level].presence || :not_assigned
    @parent_id       = params[:parent_id]
    @user = User.new(hierarchy_level: @hierarchy_level, parent_id: @parent_id)

    # ✅ Para navegación dentro de <turbo-frame id="modal"> devolvemos HTML envuelto
    respond_to do |format|
      format.turbo_stream { render :new }
      format.html do
        if turbo_frame_request?
          render :new, layout: false    # renderiza new.html.erb (con el wrapper del frame)
        else
          render :new
        end
      end
      # ❌ No respondas turbo_stream en new
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    @user = User.new(user_params)
  
    if @user.save
      if params[:from] == "hierarchy"
        if @user.collector?
          collection = Collection.create!(name: @user.username, payment_term: PaymentTerm.first) # ajustar según lógica
          CollectionUser.create!(user: @user, collection: collection)
        end
        if request.format.turbo_stream?
          # Capturamos el partial como string (NO otro render del controller)
          list_html = render_to_string(
            partial: "users/user_list",
            locals:  user_list_locals_for(@user)
          )
  
          render turbo_stream: [
            # Mantener el frame, solo vaciar su contenido
            turbo_stream.update("modal", ""),
            # Actualizar el contenido del frame de la columna correspondiente
            turbo_stream.update(frame_id_for(@user.hierarchy_level), list_html)
          ]
          return
        else
          redirect_to hierarchy_users_path(keep_params_for(@user)),
                      notice: "Usuario creado exitosamente"
          return
        end
      else
        redirect_to users_path, notice: "Usuario creado exitosamente"
        return
      end
    else
      if turbo_frame_request?
        # Devolver HTML envuelto en el frame (igual que new)
        render :new, status: :unprocessable_entity, layout: false
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
  

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "Usuario actualizado exitosamente"
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  

  def hierarchy
    @owners             = User.where(hierarchy_level: :owner)
    @selected_owner     = User.find_by(id: params[:selected_owner_id])
    @partners           = @selected_owner&.children || []

    @selected_partner   = User.find_by(id: params[:selected_partner_id])
    @collectors         = @selected_partner&.children || []

    @selected_collector = User.find_by(id: params[:selected_collector_id])
    @charges            = @selected_collector&.children || []

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # ✅ Permití hierarchy_level y parent_id. Unificá national_id / id_number en tu modelo/db si podés.
  def user_params
    params.require(:user).permit(
      :username, :password,
      :email, :full_name, :phone,
      :national_id, :id_number,
      :address, :status_id, :role_id, :city_id, :reason_block,
      :hierarchy_level, :parent_id
    )
  end

  # === helpers para refrescar el frame correcto y mantener selección ===
  # IDs de frames en tu vista:
  # - "collectors"  => columna Partners
  # - "charges"     => columna Collectors
  # - "charge_info" => columna Charge Info
  def frame_id_for(level)
    case level.to_s
    when "partner"   then "collectors"
    when "collector" then "charges"
    when "charge"    then "charge_info"
    else                  "owners"
    end
  end

  def user_list_locals_for(user)
    case user.hierarchy_level.to_sym
    when :partner
      { users: User.where(parent_id: user.parent_id, hierarchy_level: :partner),
        next_level: :selected_partner_id, level: :partner, parent_id: user.parent_id }
    when :collector
      { users: User.where(parent_id: user.parent_id, hierarchy_level: :collector),
        next_level: :selected_collector_id, level: :collector, parent_id: user.parent_id }
    when :charge
      { users: User.where(parent_id: user.parent_id, hierarchy_level: :charge),
        next_level: nil, level: :charge, parent_id: user.parent_id }
    else
      { users: User.owner, next_level: :selected_owner_id, level: :owner, parent_id: nil }
    end
  end

  def keep_params_for(user)
    case user.hierarchy_level.to_sym
    when :partner   then { selected_owner_id: user.parent_id }
    when :collector then { selected_partner_id: user.parent_id }
    when :charge    then { selected_collector_id: user.parent_id }
    else {}
    end
  end
end

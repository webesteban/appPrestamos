class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update]
  
    def index
      @users = User.includes(:status, :role, :city).all
    end
  
    def new
      @user = User.new
      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def edit
      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to users_path, notice: "Usuario creado exitosamente"
      else
        render :new, status: :unprocessable_entity, formats: [:turbo_stream]
      end
    end
  
    def update
      if @user.update(user_params)
        redirect_to users_path, notice: "Usuario actualizado exitosamente"
      else
        render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
      end
    end

    def hierarchy
        @owners = User.where(hierarchy_level: :owner)
        @selected_owner = User.find_by(id: params[:selected_owner_id])
        @partners = @selected_owner&.children || []

        @selected_partner = User.find_by(id: params[:selected_partner_id])
        @collectors = @selected_partner&.children || []

        @selected_collector = User.find_by(id: params[:selected_collector_id])
        @charges = @selected_collector&.children || []

        respond_to do |format|
            format.html # renders the view
            format.turbo_stream # for Turbo updates
        end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(
        :username, :password, :email, :full_name,
        :phone, :id_number, :address,
        :status_id, :role_id, :city_id, :reason_block
      )
    end
  end
  
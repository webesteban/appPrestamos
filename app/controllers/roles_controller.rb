class RolesController < ApplicationController
  def index
    @q = Role.ransack(params[:q])
    @pagy, @roles = pagy(@q.result, items: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  
  def new
    @role = Role.new
    respond_to do |format|
      format.turbo_stream
    end
  end
  
  def edit
    @role = Role.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end
  
  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path, notice: "Modulo creada exitosamente"
    else
      render :new, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end
  
  def update
    @role = Role.find(params[:id])
    if @role.update(role_params)
      redirect_to roles_path, notice: "Modulo actualizada exitosamente"
    else
      render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end
    
  private
    
    def role_params
      params.require(:role).permit(:name, :description)
    end
end

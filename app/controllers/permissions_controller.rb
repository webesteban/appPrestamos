class PermissionsController < ApplicationController
  def index
    @q = Permission.ransack(params[:q])
    @pagy, @permissions = pagy(@q.result, items: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  
  def new
    @permission = Permission.new
    respond_to do |format|
      format.turbo_stream
    end
  end
  
  def edit
    @permission = Permission.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end
  
  def create
    @permission = Permission.new(permission_params)
    if @permission.save
      redirect_to permissions_path, notice: "Modulo creada exitosamente"
    else
      render :new, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end
  
  def update
    @permission = Permission.find(params[:id])
    if @permission.update(permission_params)
      redirect_to permissions_path, notice: "Modulo actualizada exitosamente"
    else
      render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
    end
  end
  
  private
  
  def permission_params
    params.require(:permission).permit(:name, :code, :description)
  end
end

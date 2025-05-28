class SectionPermissionsController < ApplicationController
    def index
      @section_permissions = SectionPermission.includes(:section, :permission).all
    end
  
    def new
      @section_permission = SectionPermission.new
      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def edit
      @section_permission = SectionPermission.find(params[:id])
      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def create
      @section_permission = SectionPermission.new(section_permission_params)
      if @section_permission.save
        redirect_to section_permissions_path, notice: "Asignación creada exitosamente"
      else
        render :new, status: :unprocessable_entity, formats: [:turbo_stream]
      end
    end
  
    def update
      @section_permission = SectionPermission.find(params[:id])
      if @section_permission.update(section_permission_params)
        redirect_to section_permissions_path, notice: "Asignación actualizada exitosamente"
      else
        render :edit, status: :unprocessable_entity, formats: [:turbo_stream]
      end
    end
  
    private
  
    def section_permission_params
      params.require(:section_permission).permit(:section_id, :permission_id)
    end
  end
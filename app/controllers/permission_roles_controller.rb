class PermissionRolesController < ApplicationController
  before_action :set_roles_and_sections

  def index
    @selected_role = Role.find_by(id: params[:role_id])
    @selected_section = Section.find_by(id: params[:section_id])

    if @selected_role && @selected_section
      @permission = PermissionRole.find_or_initialize_by(role: @selected_role, section: @selected_section)
    end
  end

  def create
    @permission = PermissionRole.new(permission_role_params)

    if @permission.save
      redirect_to permission_roles_path(role_id: @permission.role_id, section_id: @permission.section_id), notice: "Permisos asignados correctamente."
    else
      redirect_to permission_roles_path, alert: "Error al asignar permisos."
    end
  end

  def update
    @permission = PermissionRole.find(params[:id])

    if @permission.update(permission_role_params)
      redirect_to permission_roles_path(role_id: @permission.role_id, section_id: @permission.section_id), notice: "Permisos actualizados correctamente."
    else
      redirect_to permission_roles_path, alert: "Error al actualizar permisos."
    end
  end

  private

  def set_roles_and_sections
    @roles = Role.all
    @sections = Section.all
  end

  def permission_role_params
    params.require(:permission_role).permit(:role_id, :section_id, :can_view, :can_create, :can_edit, :can_destroy)
  end
end

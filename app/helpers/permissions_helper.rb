module PermissionsHelper
  def can_action?(action, section_code, role = current_user.role)
    return false unless role && section_code.present?

    # Acceso completo para administradores
    return true if role.name.downcase == "administrador"

    section = Section.find_by(code: section_code)
    return false unless section

    permission = PermissionRole.find_by(role_id: role.id, section_id: section.id)
    return false unless permission

    permission.public_send("can_#{action}")
  end
end

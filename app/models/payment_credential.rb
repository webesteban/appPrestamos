class PaymentCredential < ApplicationRecord
    enum :status, { active: 0, inactive: 1 }

    
    before_save :deactivate_others_if_active

    def status_name
        case status
        when "active"
        "Activo"
        when "inactive"
        "Inactivo"
        else
        "Desconocido"
        end
    end

    private
  
    def deactivate_others_if_active
      return unless active?
  
      # Desactiva todos los demás que estén activos o pendientes
      PaymentCredential.where.not(id: id).update_all(status: :inactive)
    end
end

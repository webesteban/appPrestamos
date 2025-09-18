require 'pagy/extras/bootstrap'  # si usas Bootstrap
module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_class_for(flash_type)
      case flash_type.to_sym
      when :notice then "success"
      when :alert  then "danger"
      when :error  then "danger"
      else flash_type.to_s
      end
  end


  def loan_status(client, loan)
    today = Date.today
    loan_start = loan.created_at.to_date
  
    # Si el préstamo está pagado o cancelado → todo 0
    if loan.paid? || loan.canceled?
      return {
        overdue_days: 0,
        days_without_payment: 0,
        btn_class: "rounded-4 text-white text-bg-dark p-1 "
      }
    end
  
    total_days = (today - loan_start).to_i
    paid_days = loan.payments.select("DISTINCT DATE(paid_at)").count
    overdue_days = total_days - paid_days
  
    last_payment = loan.payments.order(paid_at: :desc).first
    days_without_payment =
      if last_payment.present?
        (today - last_payment.paid_at.to_date).to_i
      else
        total_days
      end
    overdue_days = overdue_days < 0 ? 0 : overdue_days
  
    # Mapear a colores estándar de Bootstrap
    btn_class =
      case overdue_days.to_i
      when 0..10   then "text-bg-dark"  # gris
      when 11..20  then "bg-warning"    # amarillo
      when 21..30  then "bg-secondary"  # morado/gris azulado
      when 31..40  then "bg-primary"    # azul oscuro
      when 41..50  then "bg-info"       # azul claro
      when 51..60  then "bg-danger"     # rojo
      else              "bg-success"    # verde oscuro (más de 60)
      end
  
    {
      overdue_days: overdue_days < 0 ? 0 : overdue_days,
      days_without_payment: days_without_payment,
      btn_class: "rounded-4 text-white #{btn_class} p-1 "
    }
  end
  
end

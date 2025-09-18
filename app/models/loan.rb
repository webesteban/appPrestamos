class Loan < ApplicationRecord
  TOLERANCE = BigDecimal("0.01")

  belongs_to :payment_term
  belongs_to :client
  has_many :payments, dependent: :destroy

  validates :installment_days, :amount, presence: true

  enum :status, { active: 0, overdue: 1, paid: 2, canceled: 3 }

  before_create :set_total_and_end_date

  # --- Finanzas ---
  def total_paid
    payments.sum(:amount)
  end

  def remaining_balance
    BigDecimal(total_with_interest.to_s) - BigDecimal(total_paid.to_s)
  end

  # --- Reglas de negocio para estado ---
  def should_be_paid?
    remaining_balance <= TOLERANCE
  end

  def should_be_overdue?(today = Date.today)
    today > (end_date || created_at.to_date + installment_days.days) && !should_be_paid?
  end

  def should_be_active?(today = Date.today)
    !should_be_paid? && !should_be_overdue?(today)
  end

  def recalc_status!(today = Date.today)
    return if canceled?

    target =
      if should_be_paid?
        :paid
      elsif should_be_overdue?(today)
        :overdue
      else
        :active
      end

    update!(status: target) if status.to_sym != target
  end

  def self.recalc_all_statuses!(today = Date.today)
    find_in_batches(batch_size: 1000) do |batch|
      batch.each { |loan| loan.recalc_status!(today) }
    end
  end

  def status_in_spanish
    case status.to_sym
    when :active   then "Activo"
    when :overdue  then "En mora"
    when :paid     then "Pagado"
    when :canceled then "Cancelado"
    else "Desconocido"
    end
  end

  # Devuelve una clase de color Bootstrap
  def status_color_class
    case status.to_sym
    when :active   then "bg-success rounded-4 text-white p-1"  # verde
    when :overdue  then "bg-danger rounded-4 text-white p-1"   # rojo
    when :paid     then "bg-primary rounded-4 text-white p-1"  # azul
    when :canceled then "bg-dark rounded-4 text-white p-1"     # negro
    else "bg-secondary rounded-4 text-white p-1"
    end
  end

  def status_metrics
    today = Date.today
    loan_start = created_at.to_date

    # días transcurridos desde el inicio
    total_days = (today - loan_start).to_i

    # días que sí tienen pagos
    paid_days = payments.select("DISTINCT DATE(paid_at)").count

    # días de atraso
    overdue_days = total_days - paid_days

    # último pago
    last_payment = payments.order(paid_at: :desc).first
    days_without_payment =
      if last_payment.present?
        (today - last_payment.paid_at.to_date).to_i
      else
        total_days
      end
    overdue_days = overdue_days < 0 ? 0 : overdue_days
    # Mapear a clases de Bootstrap (igual que en helper)
    btn_class =
      case overdue_days
      when 0..10   then "rounded-4 text-white text-bg-dark p-1"
      when 11..20  then "rounded-4 text-white bg-warning p-1"
      when 21..30  then "rounded-4 text-white bg-secondary p-1"
      when 31..40  then "rounded-4 text-white bg-primary p-1"
      when 41..50  then "rounded-4 text-white bg-info p-1"
      when 51..60  then "rounded-4 text-white bg-danger p-1"
      else              "rounded-4 text-white bg-success p-1"
      end

    {
      overdue_days: overdue_days,
      days_without_payment: days_without_payment,
      btn_class: btn_class
    }
  end

  def installment_value
    total_with_interest / payment_term.quota_days
  end

  private

  def set_total_and_end_date
    # congelamos monto con interés
    self.total_with_interest = BigDecimal(amount.to_s) * (1 + BigDecimal(payment_term.percentage.to_s) / 100)
    
    # fecha esperada de finalización
    base_date = created_at || Time.current
    self.end_date = base_date.to_date + installment_days.days
  end
end

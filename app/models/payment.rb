class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :loan
  belongs_to :user, optional: true 
  
  validates :user_id, presence: true, if: -> { manual? }

  enum :source, {
    manual: "manual",
    mercado_pago: "mercado_pago"
  }

  after_save :recalculate_loan_status
  after_destroy :recalculate_loan_status

  def source_name
    case source
    when "manual"
      "Manual"
    when "mercado_pago"
      "Mercado Pago"
    else
      "Desconocido"
    end
  end

  def source_color
    case source
    when "manual"
      ""
    when "mercado_pago"
      "rounded-4 text-white bg-secondary p-1"
    else
      ""
    end
  end

  private

  def recalculate_loan_status
    loan.recalc_status!
  end
end

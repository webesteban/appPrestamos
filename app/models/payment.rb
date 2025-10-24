class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :loan
  belongs_to :user
  
  validates :user_id, presence: true, if: -> { manual? }

  enum :source, {
    manual: "manual",
    mercado_pago: "mercado_pago"
  }

  after_save :recalculate_loan_status
  after_destroy :recalculate_loan_status

  private

  def recalculate_loan_status
    loan.recalc_status!
  end
end

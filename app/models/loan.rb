class Loan < ApplicationRecord
  belongs_to :payment_term
  belongs_to :client

  has_many :payments

  validates :installment_days, :amount, presence: true

  # Devuelve el monto total con interés (loan.amount + %)
  def total_with_interest
    amount.to_f * (1 + payment_term.percentage.to_f / 100)
  end
end

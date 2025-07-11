class Loan < ApplicationRecord
  belongs_to :payment_term
  belongs_to :client

  validates :installment_days, :amount, presence: true
end

class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :loan
  belongs_to :user
  
  validates :user_id, presence: true, if: -> { manual? }

  enum :source, {
    manual: "manual",
    mercado_pago: "mercado_pago"
  }
end

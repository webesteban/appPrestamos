class SettlementTopup < ApplicationRecord
  belongs_to :settlement
  validates :amount, numericality: { greater_than: 0 }
  validates :happened_at, presence: true
end
  
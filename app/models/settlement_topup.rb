class SettlementTopup < ApplicationRecord
  belongs_to :settlement
  validates :happened_at, presence: true
end
  
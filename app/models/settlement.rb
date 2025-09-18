class Settlement < ApplicationRecord
    belongs_to :collection
    belongs_to :previous_settlement, class_name: "Settlement", optional: true
  
    has_many :topups, class_name: "SettlementTopup", dependent: :destroy
    has_many :withdrawals, class_name: "SettlementWithdrawal", dependent: :destroy
  
    enum :status, {
      draft: 0,
      closed: 1,
      reliquidated: 2 
    }
  
    validates :settlement_date, presence: true
    validates :collection_id, uniqueness: { scope: :settlement_date }
    validates :base_start, :expected_cash, :difference, :base_carryover,
              :topups_total, :withdrawals_total,
              :payments_total, :loans_total, :expenses_total, :other_expenses_total,
              numericality: { greater_than_or_equal_to: 0 }
  
    # Consistencia básica
    validate :cant_be_future
  
    def cant_be_future
      errors.add(:settlement_date, "no puede ser futura") if settlement_date.present? && settlement_date > Date.today
    end
  
    # Reglas de caja
    def recompute_expected!
      self.topups_total      = topups.sum(:amount)
      self.withdrawals_total = withdrawals.sum(:amount)
  
      self.expected_cash = base_start + topups_total + payments_total - loans_total - expenses_total - withdrawals_total - other_expenses_total
      self.difference    = delivered_cash - expected_cash
      # base que queda en la ruta (si no entregó todo)
      self.base_carryover = expected_cash - delivered_cash
    end
  
    # Snapshot helpers
    def set_snapshot!(hash)
      self.snapshot = (hash || {})
    end
  end
  
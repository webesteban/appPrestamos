# frozen_string_literal: true
module Settlements
  class BuildForDay
    # persist: true => guarda/actualiza; persist: false => solo preview (no persiste)
    def self.call(collection:, date:, created_by: nil,
                  base_override: nil, other_expenses: 0, other_note: nil,
                  delivered_cash: 0, persist: true)
      new(collection, date, created_by, base_override, other_expenses, other_note, delivered_cash, persist).call
    end

    def initialize(collection, date, created_by, base_override, other_expenses, other_note, delivered_cash, persist)
      @collection     = collection
      @date           = date.to_date
      @created_by     = created_by
      @base_override  = to_d(base_override)
      @other_expenses = to_d(other_expenses)
      @other_note     = other_note
      @delivered_cash = to_d(delivered_cash)
      @persist        = persist
    end

    def call
      settlement = Settlement.find_or_initialize_by(collection_id: @collection.id, settlement_date: @date)

      prev = Settlement.where(collection_id: @collection.id)
                       .where("settlement_date < ?", @date)
                       .order(settlement_date: :desc)
                       .first

      # base_start: prioridad => override -> ya guardada -> carryover previo -> 0
      base_start = @base_override.presence || settlement.base_start || prev&.base_carryover || 0

      payments_scope = Payment.joins(loan: :client)
                              .where(clients: { collection_id: @collection.id })
                              .where("DATE(paid_at) = ?", @date)
      payments_total = to_d(payments_scope.sum(:amount))
      payments_count = payments_scope.count

      loans_scope = Loan.joins(:client)
                        .where(clients: { collection_id: @collection.id })
                        .where("DATE(loans.created_at) = ?", @date)
      loans_total = to_d(loans_scope.sum(:amount))
      loans_count = loans_scope.count

      # Ajusta si tu app usa otro modelo de gastos de ruta
      if defined?(RouteExpense)
        expenses_scope = RouteExpense.where(collection_id: @collection.id).where("DATE(spent_at) = ?", @date)
        expenses_total = to_d(expenses_scope.sum(:amount))
      elsif defined?(Expense)
        expenses_scope = Expense.where(collection_id: @collection.id).where("DATE(created_at) = ?", @date)
        expenses_total = to_d(expenses_scope.sum(:amount))
      else
        expenses_scope = nil
        expenses_total = 0
      end

      settlement.previous_settlement_id ||= prev&.id
      settlement.base_start            = base_start
      settlement.payments_total        = payments_total
      settlement.payments_count        = payments_count
      settlement.loans_total           = loans_total
      settlement.loans_count           = loans_count
      settlement.expenses_total        = expenses_total
      settlement.other_expenses_total  = @other_expenses
      settlement.other_expenses_note   = @other_note
      settlement.delivered_cash        = @delivered_cash
      settlement.status              ||= "draft"

      settlement.recompute_expected!
      settlement.set_snapshot!(
        payments: payments_scope.pluck(:id),
        loans:    loans_scope.pluck(:id),
        expenses: (expenses_scope ? expenses_scope.pluck(:id) : []),
        version:  1
      )
      settlement.recalculated_at = Time.current

      @persist ? settlement.tap(&:save!) : settlement
    end

    private

    def to_d(x)
      return 0.to_d if x.blank?
      BigDecimal(x.to_s)
    end
  end
end

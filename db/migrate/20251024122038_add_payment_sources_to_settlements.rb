class AddPaymentSourcesToSettlements < ActiveRecord::Migration[8.0]
  def change
    add_column :settlements, :payments_manual_total, :decimal, precision: 14, scale: 2, null: false, default: 0
    add_column :settlements, :payments_mercado_pago_total, :decimal, precision: 14, scale: 2, null: false, default: 0

    add_column :settlements, :payments_manual_count, :integer, null: false, default: 0
    add_column :settlements, :payments_mercado_pago_count, :integer, null: false, default: 0
  end
end

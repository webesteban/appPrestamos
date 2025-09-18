class CreateSettlementWithdrawals < ActiveRecord::Migration[8.0]
  def change
    create_table :settlement_withdrawals do |t|
      t.references :settlement, null: false, foreign_key: true
      t.decimal :amount, precision: 14, scale: 2, null: false, default: 0
      t.string  :destination # oficina principal, banco, etc.
      t.string  :note
      t.bigint  :user_id, index: true
      t.datetime :happened_at, null: false
      t.timestamps
    end
  end
end

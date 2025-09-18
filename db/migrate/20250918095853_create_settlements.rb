class CreateSettlements < ActiveRecord::Migration[8.0]
  def change
    create_table :settlements do |t|
      t.references :collection, null: false, foreign_key: true, index: true

      t.date    :settlement_date, null: false, index: true
      t.bigint  :previous_settlement_id, index: true

      # Totales base y movimientos "propios" de la caja de la ruta
      t.decimal :base_start,           precision: 14, scale: 2, null: false, default: 0   # base al iniciar el día (traída del anterior o ingresada)
      t.decimal :topups_total,         precision: 14, scale: 2, null: false, default: 0   # retanqueos del día
      t.decimal :withdrawals_total,    precision: 14, scale: 2, null: false, default: 0   # retiros del día (a oficina)

      # Totales agregados desde el dominio
      t.integer :payments_count,       null: false, default: 0
      t.decimal :payments_total,       precision: 14, scale: 2, null: false, default: 0

      t.integer :loans_count,          null: false, default: 0
      t.decimal :loans_total,          precision: 14, scale: 2, null: false, default: 0   # “compras” del día

      t.decimal :expenses_total,       precision: 14, scale: 2, null: false, default: 0   # gastos del modelo de gastos de ruta
      t.decimal :other_expenses_total, precision: 14, scale: 2, null: false, default: 0   # otros gastos manuales
      t.string  :other_expenses_note

      # Entregado y cálculo final
      t.decimal :delivered_cash,       precision: 14, scale: 2, null: false, default: 0   # lo que el cobrador dice entregar
      t.decimal :expected_cash,        precision: 14, scale: 2, null: false, default: 0   # calculado
      t.decimal :difference,           precision: 14, scale: 2, null: false, default: 0   # delivered - expected

      # Base que queda al cierre y arrastra al próximo día
      t.decimal :base_carryover,       precision: 14, scale: 2, null: false, default: 0

      # Estado
      t.integer :status, null: false, default: 0 # draft, closed, reliquidated

      # Auditoría
      t.bigint :created_by_id, index: true
      t.bigint :updated_by_id, index: true
      t.datetime :recalculated_at
      t.jsonb :snapshot, default: {} # IDs y detalles “raw” usados para esta liquidación (pagos, compras, gastos)

      t.integer :lock_version, null: false, default: 0 # optimistic locking

      t.timestamps
    end

    add_index :settlements, [:collection_id, :settlement_date], unique: true
    add_foreign_key :settlements, :settlements, column: :previous_settlement_id
  end
end

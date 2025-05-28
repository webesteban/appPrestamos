class CreateExpenseTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :expense_types do |t|
      t.string :name
      t.decimal :max_value

      t.timestamps
    end
  end
end

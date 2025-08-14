class AddActiveToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :active, :boolean, default: true, null: false
  end
end

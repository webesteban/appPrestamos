class AddCollectionToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_reference :expenses, :collection, null: false, foreign_key: true
  end
end

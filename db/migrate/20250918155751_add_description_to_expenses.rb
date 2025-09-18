class AddDescriptionToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :description, :text
  end
end

class AddStatusToLoans < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :status, :integer, default: 0, null: false
    add_index  :loans, :status
  end
end

class AddParentIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :parent_id, :integer
    add_index :users, :parent_id
    add_column :users, :hierarchy_level, :integer, default: 0, null: false
  end
end

class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :description
      t.string :code

      t.timestamps
    end
  end
end

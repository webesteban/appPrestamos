class CreatePermissionRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :permission_roles do |t|
      t.references :role, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.boolean :can_view
      t.boolean :can_create
      t.boolean :can_edit
      t.boolean :can_destroy

      t.timestamps
    end
  end
end

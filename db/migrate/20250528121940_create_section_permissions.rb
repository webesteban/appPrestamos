class CreateSectionPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :section_permissions do |t|
      t.references :section, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end
  end
end

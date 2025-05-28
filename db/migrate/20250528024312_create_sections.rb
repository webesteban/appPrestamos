class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end

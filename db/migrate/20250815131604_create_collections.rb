class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.string :plate
      t.string :phone
      t.string :email
      t.string :city
      t.decimal :min_value
      t.decimal :max_value
      t.integer :payment_method
      t.references :payment_term, null: false, foreign_key: true

      t.timestamps
    end
  end
end

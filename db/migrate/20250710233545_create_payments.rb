class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :client, null: false, foreign_key: true
      t.references :loan, null: false, foreign_key: true
      t.references :user, null: true
      t.decimal :amount
      t.decimal :latitude
      t.decimal :longitude
      t.date :paid_at
      t.text :details

      t.timestamps
    end
  end
end

class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_table :loans do |t|
      t.references :payment_term, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.integer :installment_days
      t.decimal :amount
      t.text :details
      t.decimal :insurance_amount
      t.boolean :insurance

      t.timestamps
    end
  end
end

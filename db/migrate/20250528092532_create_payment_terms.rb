class CreatePaymentTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_terms do |t|
      t.integer :percentage
      t.integer :quota_days
      t.string :payment_frequency
      t.integer :payment_days
      t.boolean :monthly

      t.timestamps
    end
  end
end

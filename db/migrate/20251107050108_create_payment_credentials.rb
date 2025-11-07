class CreatePaymentCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_credentials do |t|
      t.string :name
      t.string :access_token
      t.string :country
      t.string :client_id
      t.string :client_secret
      t.integer :status, default: 0, null: false  # 👈 enum status

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :persistence_token
      t.string :password_salt

      t.string :single_access_token
      t.string :perishable_token

      # See "Magic Columns" in Authlogic::Session::Base
      t.integer   :login_count, default: 0, null: false
      t.integer   :failed_login_count, default: 0, null: false
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip


      t.string :salt
      t.string :full_name
      t.string :national_id
      t.string :phone
      t.string :address
      t.references :status, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.string :reason_block
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end

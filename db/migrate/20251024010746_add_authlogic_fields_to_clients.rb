class AddAuthlogicFieldsToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :username, :string
    add_column :clients, :crypted_password, :string
    add_column :clients, :password_salt, :string
    add_column :clients, :persistence_token, :string
    add_column :clients, :single_access_token, :string
    add_column :clients, :perishable_token, :string
    add_column :clients, :login_count, :integer
    add_column :clients, :failed_login_count, :integer
    add_column :clients, :last_request_at, :datetime
    add_column :clients, :current_login_at, :datetime
    add_column :clients, :last_login_at, :datetime
    add_column :clients, :current_login_ip, :string
    add_column :clients, :last_login_ip, :string
    add_column :clients, :api_token, :string
  end
end

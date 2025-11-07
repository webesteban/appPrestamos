class MakeUserIdNullableInPayments < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :payments, :users
    change_column_null :payments, :user_id, true
    add_foreign_key :payments, :users
  end
end

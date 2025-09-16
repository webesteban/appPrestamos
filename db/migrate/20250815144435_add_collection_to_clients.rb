class AddCollectionToClients < ActiveRecord::Migration[8.0]
  def change
    add_reference :clients, :collection, null: false, foreign_key: true
  end
end

class UpdatePaymentsForMercadoPagoIntegration < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :external_reference, :string
    add_column :payments, :source, :string, null: false, default: "manual"
  end
end

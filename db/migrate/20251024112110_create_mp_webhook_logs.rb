class CreateMpWebhookLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :mp_webhook_logs do |t|
      t.string :topic
      t.json :payload
      t.boolean :attempted
      t.string :message
      t.string :payment_id
      t.string :external_reference

      t.timestamps
    end
  end
end

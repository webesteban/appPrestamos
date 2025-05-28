class CreateThirdPartyTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :third_party_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end

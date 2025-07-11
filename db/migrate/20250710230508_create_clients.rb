class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :identification
      t.string :identification_type
      t.string :full_name
      t.date :identification_issued_at
      t.date :birth_date
      t.string :sex
      t.string :address
      t.string :mobile_phone
      t.string :landline_phone
      t.string :billing_address
      t.string :occupation
      t.string :workplace
      t.decimal :income
      t.string :reference1_name
      t.string :reference1_identification
      t.string :reference1_address
      t.string :reference1_phone
      t.string :reference2_name
      t.string :reference2_identification
      t.string :reference2_address
      t.string :reference2_phone
      t.string :email
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end

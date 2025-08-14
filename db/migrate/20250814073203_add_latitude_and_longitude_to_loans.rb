class AddLatitudeAndLongitudeToLoans < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :latitude, :decimal, precision: 10, scale: 6
    add_column :loans, :longitude, :decimal, precision: 10, scale: 6
  end
end

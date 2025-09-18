class AddTotalWithInterestAndEndDateToLoans < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :total_with_interest, :decimal
    add_column :loans, :end_date, :date
  end
end

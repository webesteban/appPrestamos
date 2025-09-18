class Expense < ApplicationRecord
  belongs_to :expense_type, optional: true
  belongs_to :user, optional: true
  belongs_to :collection

  scope :for_day, ->(collection_id, date) {
    where(collection_id: collection_id).where("DATE(created_at) = ?", date)
  }

  def expense_name
    expense_type_id.nil? ? description : expense_type.name
  end
end

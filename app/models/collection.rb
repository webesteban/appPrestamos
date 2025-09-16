class Collection < ApplicationRecord
  belongs_to :payment_term

  has_many :collection_users
  has_many :users, through: :collection_users

  validates :name, presence: true
end
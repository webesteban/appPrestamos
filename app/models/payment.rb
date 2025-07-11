class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :loan
  belongs_to :user
end

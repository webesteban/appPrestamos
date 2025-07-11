class Client < ApplicationRecord
    validates :identification, :full_name, :birth_date, presence: true
end

class Client < ApplicationRecord
    has_many :loans

    validates :identification, :full_name, :birth_date, presence: true

    def self.ransackable_attributes(auth_object = nil)
        %w[full_name identification email]
    end

    def self.ransackable_associations(auth_object = nil)
        []
    end
end

class Role < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        %w[name description]
    end

    def self.ransackable_associations(auth_object = nil)
        []
    end
end

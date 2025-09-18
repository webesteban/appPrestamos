class Client < ApplicationRecord

    belongs_to :collection
    has_many :loans
    has_many :payments, through: :loans

    validates :identification, :full_name, presence: true

    

    def total_loans_with_interest
        loans.sum { |loan| loan.total_with_interest }
    end

    def total_payments
        payments.sum(:amount)
    end

    def balance
        total_loans_with_interest - total_payments
    end

    def self.ransackable_attributes(auth_object = nil)
        %w[full_name identification email]
    end

    def self.ransackable_associations(auth_object = nil)
        []
    end



end

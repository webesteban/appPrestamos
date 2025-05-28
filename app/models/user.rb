class User < ApplicationRecord
  acts_as_authentic do |c|
    c.login_field = :username
    c.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end

  
  belongs_to :status
  belongs_to :role
  belongs_to :city
  belongs_to :parent, class_name: 'User', optional: true
  has_many :children, class_name: 'User', foreign_key: :parent_id

  enum :hierarchy_level, { not_assigned: 0, owner: 1, partner: 2, collector: 3, charge: 4 }

  def name_with_role
    "#{full_name} (#{hierarchy_level})"
  end

end

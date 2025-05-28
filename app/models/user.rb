class User < ApplicationRecord
  acts_as_authentic do |c|
    c.login_field = :username
    c.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end
  
  belongs_to :status
  belongs_to :role
  belongs_to :city
end

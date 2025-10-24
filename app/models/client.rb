# app/models/client.rb
class Client < ApplicationRecord
  acts_as_authentic do |c|
    c.login_field = :username
    c.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end

  belongs_to :collection
  has_many :loans
  has_many :payments, through: :loans

  validates :identification, :full_name, :username, presence: true

  validates :password, format: {
    with: /\A\d{4}\z/,
    message: "debe ser un código de 4 dígitos numéricos"
  }, if: :password_required?

  before_validation :set_default_password_from_identification, on: :create
  before_create :generate_api_token
  before_validation :set_default_username_from_identification, on: :create

  def total_loans_with_interest
    loans.sum { |loan| loan.total_with_interest }
  end

  def total_payments
    payments.sum(:amount)
  end

  def balance
    total_loans_with_interest - total_payments
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[full_name identification email username]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def password_required?
    crypted_password.blank? || password.present?
  end

  def set_default_password_from_identification
    return if password.present? || identification.blank?
    last4 = identification.to_s[-4..] || "0000"
    self.password = last4
  end

  def generate_api_token
    self.api_token ||= SecureRandom.hex(32)
  end

  def set_default_username_from_identification
    return if username.present? || identification.blank?

    self.username = identification.to_s
  end
end

class User < ApplicationRecord
  has_secure_password

  has_one :trade
  has_one :user, through: :trade

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :token, presence:  true
  validates :password_confirmation, presence: true

  after_initialize :add_token

  private

  def add_token
    self.token = calculate_token if self.new_record? && self.token.blank?
  end

  def calculate_token
    token = generate_token
    token = generate_token while User.exists?(token: token)
    token
  end

  def generate_token
    SecureRandom.hex(16)
  end
end

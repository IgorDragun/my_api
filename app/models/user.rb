class User < ApplicationRecord
  has_secure_password

  has_one :trade
  has_one :user, through: :trade

  validates :name, presence: true, uniqueness: true, length: { minimum:5, maximum: 50 }
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

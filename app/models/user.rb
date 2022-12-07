# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :inventories, dependent: :destroy
  has_one :trade, dependent: :destroy
  has_one :user, through: :trade

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :token, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: :new_record?
  validates :password_confirmation, presence: true, if: :new_record?

  after_initialize :add_token

  def withdrawal(sum)
    update(balance: self.balance -= sum)
  end

  def enough_balance?(sum)
    balance >= sum
  end

  private

  def add_token
    self.token = calculate_token if new_record? && token.blank?
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

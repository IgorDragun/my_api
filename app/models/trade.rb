class Trade < ApplicationRecord
  belongs_to :user
  has_one :user

  validates :initiator_id, presence: true, numericality: { only_integer: true }
  validates :receiver_id, presence: true, numericality: { only_integer: true }
  validates :status, presence: true
end

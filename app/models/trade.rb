# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"

  validates :buyer_id, numericality: { only_integer: true }
  validates :seller_id, numericality: { only_integer: true }
  validates :seller_inventory_id, presence: true, numericality: { only_integer: true }
  validates :offered_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  enum status: {
    waiting_for_accept: 1,
    accepted: 2,
    canceled_by_receiver: 3,
    declined_by_initiator: 4
  }
end

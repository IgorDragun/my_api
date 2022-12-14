# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"

  validates :buyer_id, presence: true, numericality: { only_integer: true }
  validates :seller_id, presence: true, numericality: { only_integer: true }
  validates :seller_inventory_id, presence: true, numericality: { only_integer: true }
  validates :offered_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, numericality: { only_integer: true }
end

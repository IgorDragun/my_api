# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :shop

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def reduction
    update(count: self.count -= 1)
  end

  def positive?
    count.positive?
  end
end

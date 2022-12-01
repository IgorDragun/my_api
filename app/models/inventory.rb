class Inventory < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :cost, presence: true, numericality: { greater_than: 0 }
end

class Shop < ApplicationRecord
  has_many :items

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end

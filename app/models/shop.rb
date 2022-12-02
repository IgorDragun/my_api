# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end

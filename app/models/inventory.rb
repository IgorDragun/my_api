# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 50 }
  validates :cost, presence: true, numericality: { greater_than: 0 }

  def change_owner(new_owner, new_cost)
    update!(user_id: new_owner.id, cost: new_cost)
  end
end

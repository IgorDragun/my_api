# frozen_string_literal: true

class Trade < ApplicationRecord
  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_one :user
  # rubocop:enable Rails/HasManyOrHasOneDependent

  validates :initiator_id, presence: true, numericality: { only_integer: true }
  validates :receiver_id, presence: true, numericality: { only_integer: true }
  validates :status, presence: true
end

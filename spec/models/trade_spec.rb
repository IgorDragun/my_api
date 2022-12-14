# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trade, type: :model do
  subject(:trade) { build(:trade) }

  describe "validates" do
    it { is_expected.to validate_presence_of(:buyer_id) }
    it { is_expected.to validate_presence_of(:seller_id) }
    it { is_expected.to validate_presence_of(:seller_inventory_id) }
    it { is_expected.to validate_presence_of(:offered_price) }
    it { is_expected.to validate_presence_of(:status) }

    it { is_expected.to validate_numericality_of(:buyer_id) }
    it { is_expected.to validate_numericality_of(:seller_id) }
    it { is_expected.to validate_numericality_of(:seller_inventory_id) }
    it { is_expected.to validate_numericality_of(:offered_price) }
    it { is_expected.to validate_numericality_of(:status) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:buyer) }
    it { is_expected.to belong_to(:seller) }
  end
end

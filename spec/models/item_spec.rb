# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  subject(:item) { build(:item, shop_id: shop.id) }

  let(:shop) { create(:shop) }

  describe "validates" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:count) }

    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to validate_length_of(:name) }

    it { is_expected.to validate_numericality_of(:price) }
    it { is_expected.to validate_numericality_of(:count) }
  end
end

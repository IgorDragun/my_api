# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { build(:item, shop_id: shop.id) }
  let(:shop) { create(:shop) }

  describe "validates" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:count) }
    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_numericality_of(:price) }
    it { is_expected.to validate_numericality_of(:count) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:shop) }
  end

  describe "#count_reduce" do
    it "reduces count of item by one" do
      expect { item.count_reduce }.to change(item, :count).by(-1)
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Inventory, type: :model do
  subject(:inventory) { build(:inventory, user_id: user.id) }

  let(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validates" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cost) }

    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to validate_length_of(:name) }

    it { is_expected.to validate_numericality_of(:cost) }
  end
end

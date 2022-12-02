require 'rails_helper'

RSpec.describe Inventory, type: :model do
  let(:user) { create(:user) }
  subject(:inventory) { build(:inventory, user_id: user.id) }

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

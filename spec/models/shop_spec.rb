# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shop, type: :model do
  subject(:shop) { build(:shop) }

  describe "validates" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end

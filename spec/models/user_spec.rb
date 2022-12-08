# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "secure password" do
    it { is_expected.to have_secure_password }
  end

  describe "associations" do
    it { is_expected.to have_many(:inventories) }
    it { is_expected.to have_one(:trade) }
    it { is_expected.to have_one(:user) }
  end

  describe "validates" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }

    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_length_of(:password) }

    it { is_expected.to validate_numericality_of(:balance) }
  end

  context "when create new record" do
    it "adds a token" do
      expect(user.token).not_to be_nil
    end
  end

  describe "#withdrawal" do
    let(:item) { build(:item) }

    it "reduces user balance by item price" do
      expect { user.withdrawal(item.price) }.to change(user, :balance).by(- item.price)
    end
  end
end

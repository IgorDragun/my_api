# frozen_string_literal: true

require "rails_helper"

RSpec.describe Inventory, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validates" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cost) }
    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_numericality_of(:cost) }
  end

  describe "#change_owner" do
    let(:inventory) { create(:inventory, user_id: old_owner.id) }
    let(:old_owner) { create(:user, id: 1) }
    let(:new_owner) { create(:user, id: 2, name: "New Owner", email: "new_owner@gmail.com") }
    let(:new_cost) { inventory.cost + 100 }

    it "changes inventory owner" do
      expect { inventory.change_owner(new_owner, new_cost) }.to change(inventory, :user_id)
    end

    it "changes inventory cost" do
      expect { inventory.change_owner(new_owner, new_cost) }.to change(inventory, :cost)
    end
  end
end

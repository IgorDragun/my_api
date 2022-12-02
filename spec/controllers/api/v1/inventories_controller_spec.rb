require 'rails_helper'

RSpec.describe Api::V1::InventoriesController, type: :controller do
  describe "GET /index" do
    subject(:send_request) { get :index, params: { api_token: user.token} }

    let(:user) { build(:user, inventories: [inventory]) }
    let(:inventory) { build(:inventory) }
    let(:result) { { status: "success", inventories: [inventory] } }

    before do
      allow(User).to receive(:find_by).with(token: user.token).and_return(user)
    end

    context "when user exist" do
      it "returns user's inventories" do
        send_request

        expect(response.body).to eq(result.to_json)
      end
    end
  end
end

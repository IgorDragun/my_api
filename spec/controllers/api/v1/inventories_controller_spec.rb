# frozen_string_literal: true

require "rails_helper"
require "shared_examples/authenticate"

RSpec.describe Api::V1::InventoriesController, type: :controller do
  describe "GET /index" do
    subject(:send_request) { get :index, params: params }

    let(:params) { { api_token: user.token } }
    let(:user) { build(:user, inventories: [inventory]) }
    let(:inventory) { build(:inventory) }
    let(:result) { { status: "success", inventories: [inventory] } }

    include_examples "testing user authenticate"

    context "when user exist" do
      before do
        allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(user)
      end

      it "returns user's inventories" do
        send_request

        expect(response.body).to eq(result.to_json)
      end
    end
  end
end

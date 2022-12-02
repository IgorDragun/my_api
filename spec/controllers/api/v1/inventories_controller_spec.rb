# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::InventoriesController, type: :controller do
  describe "GET /index" do
    subject(:send_request) { get :index, params: params }

    let(:params) { { api_token: user.token } }
    let(:user) { build(:user, inventories: [inventory]) }
    let(:inventory) { build(:inventory) }
    let(:result) { { status: "success", inventories: [inventory] } }

    context "when user exist" do
      before do
        allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(user)
      end

      it "returns user's inventories" do
        send_request

        expect(response.body).to eq(result.to_json)
      end
    end

    context "when user does not exist" do
      before do
        allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(nil)
      end

      it "returns status 422" do
        send_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

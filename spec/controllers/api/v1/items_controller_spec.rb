# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  describe "GET /index" do
    subject(:send_request) { get :index, params: params }

    let(:params) { { api_token: user.token, shop_id: shop.id } }
    let(:user) { build(:user) }
    let(:shop) { create(:shop, items: [item]) }
    let(:item) { build(:item) }
    let(:result) { { status: "success", items: [item] } }

    before do
      allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(user)
    end

    context "when shop exist" do
      before do
        allow(Shop).to receive(:find_by).with(id: params[:shop_id]).and_return(shop)
      end

      it "returns shop;s items" do
        send_request

        expect(response.body).to eq result.to_json
      end

    end

    context "when shop does not exist" do
      before do
        allow(Shop).to receive(:find_by).with(id: params[:shop_id]).and_return(nil)
      end

      it "returns shop;s items" do
        send_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

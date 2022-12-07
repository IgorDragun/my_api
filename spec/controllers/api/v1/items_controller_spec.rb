# frozen_string_literal: true

require "rails_helper"
require "shared_examples/authenticate"

RSpec.describe Api::V1::ItemsController, type: :controller do
  before do
    allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(user)
    allow(Shop).to receive(:find_by).with(id: params[:shop_id]).and_return(shop)
  end

  let(:user) { build(:user) }
  let(:shop) { create(:shop, items: [item]) }
  let(:item) { build(:item) }

  shared_examples "it returns the error" do
    before do
      allow(Shop).to receive(:find_by).with(id: params[:shop_id]).and_return(nil)
    end

    it "returns the error" do
      send_request

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /index" do
    subject(:send_request) { get :index, params: params }

    let(:params) { { api_token: user.token, shop_id: shop.id } }
    let(:result) { { items: [item] } }

    include_examples "testing user authenticate"

    context "when the shop exist" do
      it "returns the shop's items" do
        send_request

        expect(response.body).to eq result.to_json
      end
    end

    context "when the shop does not exist" do
      include_examples "it returns the error"
    end
  end

  describe "GET /show" do
    subject(:send_request) { get :show, params: params }

    let(:params) { { api_token: user.token, shop_id: shop.id, item_id: item.id } }
    let(:result) { { item: item } }

    include_examples "testing user authenticate"

    context "when the shop exist" do
      context "when the item exist" do
        it "returns the item" do
          send_request

          expect(response.body).to eq result.to_json
        end
      end

      context "when the item does not exist" do
        let(:params) { { api_token: user.token, shop_id: shop.id, item_id: item.id + 1 } }
        let(:result) { { item: nil } }

        it "returns the error" do
          send_request

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when the shop does not exist" do
      include_examples "it returns the error"
    end
  end
end

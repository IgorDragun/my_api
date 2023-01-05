# frozen_string_literal: true

require "rails_helper"
require "shared_examples/authenticate"
require "shared_examples/shops"
require "shared_examples/items"

RSpec.describe Api::V1::ItemsController, type: :controller do
  before do
    allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(user)
    allow(Shop).to receive(:find_by).with(id: params[:shop_id]).and_return(shop)
  end

  let(:user) { build(:user) }
  let(:shop) { create(:shop) }
  let(:items) { shop.items }
  let(:item) { create(:item, shop_id: shop.id) }

  describe "GET /index" do
    subject(:send_request) { get :index, params: params }

    let(:params) { { api_token: user.token, shop_id: shop.id } }
    let(:result) { { items: items } }

    include_examples "check user authenticate"
    include_examples "check shop availability"

    it "returns the shop's items" do
      send_request

      expect(response.body).to eq result.to_json
    end
  end

  describe "GET /show" do
    subject(:send_request) { get :show, params: params }

    let(:params) { { api_token: user.token, shop_id: shop.id, item_id: item.id } }
    let(:result) { { item: item } }

    include_examples "check user authenticate"
    include_examples "check shop availability"
    include_examples "check item availability"

    it "returns the item" do
      send_request

      expect(response.body).to eq result.to_json
    end
  end

  describe "POST /buy_item" do
    subject(:send_request) { post :buy_item, params: params }

    let(:params) { { api_token: user.token, shop_id: shop.id, item_id: item.id } }
    let!(:item_count) { item.count }

    include_examples "check user authenticate"
    include_examples "check shop availability"
    include_examples "check item availability"

    context "when the item was successfully bought" do
      it "reduces the user balance" do
        expect { send_request }.to change(user, :balance).by(- item.price)
      end

      it "reduces the item count" do
        send_request
        item.reload

        expect(item.count).to eq(item_count - 1)
      end

      it "increases the user inventories count" do
        expect { send_request }.to change(user.inventories, :count).by(1)
      end
    end

    context "when the user does not have enough money" do
      let(:user) { build(:user, balance: item.price - 1) }

      include_examples "check item buy availability"
    end

    context "when the item count is zero" do
      let(:item) { create(:item, shop_id: shop.id, count: 0) }

      include_examples "check item buy availability"
    end
  end
end

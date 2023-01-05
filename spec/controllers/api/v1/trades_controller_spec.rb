# frozen_string_literal: true

require "rails_helper"
require "shared_examples/authenticate"
require "shared_examples/trades"

RSpec.describe Api::V1::TradesController, type: :controller do
  shared_examples "returns the error not_found" do
    it "returns the error" do
      send_request

      expect(response).to have_http_status(:not_found)
    end
  end

  shared_examples "returns the error unprocessable_entity" do
    it "returns the error" do
      send_request

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /create" do
    subject(:send_request) { post :create, params: params }

    let(:user) { build_stubbed(:user) }
    let(:seller) { create(:user) }
    let(:params) do
      {
        api_token: user.token,
        trade: {
          seller_id: seller.id,
          seller_inventory_id: seller_inventory.id,
          offered_price: 10.00
        }
      }
    end
    let(:seller_inventory) { create(:inventory, user: seller) }

    shared_examples "does not create new trade and returns the error" do
      it "does not create new trade" do
        expect { send_request }.not_to change(Trade, :count)
      end

      include_examples "returns the error unprocessable_entity"
    end

    include_examples "check user authenticate"
    include_examples "check seller availability"
    include_examples "check seller inventory availability"

    context "when all necessary params are valid and exist" do
      it "creates new trade" do
        expect { send_request }.to change(Trade, :count).by(1)
      end

      it "returns success status" do
        send_request

        expect(response).to have_http_status(:success)
      end
    end

    context "when not all necessary params are valid" do
      let(:params) do
        {
          api_token: user.token,
          trade: {
            seller_id: seller.id,
            seller_inventory_id: seller_inventory.id,
            offered_price: -10.00
          }
        }
      end

      include_examples "does not create new trade and returns the error"
    end

    context "when not all necessary params exist" do
      let(:params) do
        {
          api_token: user.token,
          trade: {
            seller_id: seller.id,
            seller_inventory_id: seller_inventory.id
          }
        }
      end

      include_examples "does not create new trade and returns the error"
    end
  end

  describe "GET /active_trades" do
    subject(:send_request) { get :active_trades, params: params }

    let(:params) { { api_token: user.token } }
    let(:user) { create(:user) }
    let(:seller) { create(:user, name: "Seller", email: "seller@gmail.com") }

    include_examples "check user authenticate"

    context "when user has active trades" do
      let!(:trade) { create(:trade, buyer_id: user.id, seller_id: seller.id) }
      let(:result) { { active_trades: [trade] } }

      it "returns active trades list" do
        send_request

        expect(response.body).to eq(result.to_json)
      end
    end

    context "when user does not have active trades" do
      include_examples "returns the error not_found"
    end
  end

  describe "GET /passive_trades" do
    subject(:send_request) { get :passive_trades, params: params }

    let(:params) { { api_token: user.token } }
    let!(:user) { create(:user) }
    let(:buyer) { create(:user, name: "Buyer", email: "buyer@gmail.com") }

    include_examples "check user authenticate"

    context "when user has passive trades" do
      let!(:trade) { create(:trade, buyer_id: buyer.id, seller_id: user.id) }
      let(:result) { { passive_trades: [trade] } }

      it "returns passive trades list" do
        send_request

        expect(response.body).to eq(result.to_json)
      end
    end

    context "when user does not have passive trades" do
      include_examples "returns the error not_found"
    end
  end

  describe "POST /accept" do
    subject(:send_request) { post :accept, params: params }

    let(:params) { { api_token: user.token, trade_id: trade.id } }
    let(:user) { create(:user, balance: balance) }
    let(:balance) { 1000 }
    let(:trade) do
      create(:trade, buyer_id: buyer.id, seller_id: user.id, seller_inventory_id: inventory.id,
                     offered_price: offered_price)
    end
    let(:offered_price) { 99 }
    let(:buyer) { create(:user, name: "Buyer", email: "buyer@gmail.com", balance: balance) }
    let(:inventory) { create(:inventory, user_id: user.id, cost: cost) }
    let(:cost) { 10 }

    include_examples "check user authenticate"

    context "when all checks have been completed successfully" do
      before do
        send_request

        buyer.reload
        user.reload
        inventory.reload
      end

      it "reduces buyer's balance" do
        expect(buyer.balance).to eq(balance - trade.offered_price)
      end

      it "increases seller's balance" do
        expect(user.balance).to eq(balance + trade.offered_price)
      end

      it "changes the cost of the inventory" do
        expect(inventory.cost).to eq(trade.offered_price)
      end

      it "changes the owner of the inventory" do
        expect(inventory.user_id).to eq(buyer.id)
      end
    end

    context "when user does not have passive trades" do
      let(:trade) { build_stubbed(:trade, buyer_id: buyer.id, seller_id: user.id + 1) }

      include_examples "returns the error not_found"
    end

    context "when user does not have certain passive trade" do
      let(:params) { { api_token: user.token, trade_id: trade.id + 1 } }

      include_examples "returns the error not_found"
    end

    context "when trade does not have the status waiting_for_accept" do
      let(:trade) do
        create(:trade, buyer_id: buyer.id, seller_id: user.id, seller_inventory_id: inventory.id,
                       offered_price: offered_price, status: 4)
      end

      include_examples "returns the error unprocessable_entity"
    end

    context "when user does not have the inventory" do
      let(:inventory) { build_stubbed(:inventory, user_id: user.id + 1, cost: cost) }

      include_examples "returns the error not_found"
    end

    context "when buyer does not have enough money" do
      let(:buyer) { create(:user, name: "Buyer", email: "buyer@gmail.com", balance: offered_price - 1) }

      include_examples "returns the error unprocessable_entity"
    end
  end

  describe "POST /cancel" do
    subject(:send_request) { post :cancel, params: params }

    let(:params) { { api_token: user.token, trade_id: trade.id } }
    let(:user) { create(:user) }
    let(:trade) { create(:trade, buyer_id: user.id, seller_id: seller.id) }
    let(:seller) { create(:user, name: "Seller", email: "seller@gmail.com") }

    include_examples "check user authenticate"

    it "changes the status" do
      send_request
      trade.reload

      expect(trade.status.to_sym).to eq(:canceled_by_initiator)
    end

    context "when user does not have active trades" do
      let(:trade) { build_stubbed(:trade, buyer_id: user.id + 1) }

      include_examples "returns the error not_found"
    end

    context "when user's active trades do not include required trade" do
      let(:params) { { api_token: user.token, trade_id: trade.id + 1 } }

      include_examples "returns the error not_found"
    end

    context "when required trade's status is not waiting_for_accept" do
      let(:trade) { create(:trade, buyer_id: user.id, seller_id: seller.id, status: 2) }

      include_examples "returns the error unprocessable_entity"
    end
  end

  describe "POST /decline" do
    subject(:send_request) { post :decline, params: params }

    let(:params) { { api_token: user.token, trade_id: trade.id } }
    let(:user) { create(:user) }
    let(:trade) { create(:trade, buyer_id: buyer.id, seller_id: user.id) }
    let(:buyer) { create(:user, name: "Buyer", email: "buyer@gmail.com") }

    include_examples "check user authenticate"

    it "changes the status" do
      send_request
      trade.reload

      expect(trade.status.to_sym).to eq(:declined_by_receiver)
    end

    context "when user does not have passive trades" do
      let(:trade) { build_stubbed(:trade, seller_id: user.id + 1) }

      include_examples "returns the error not_found"
    end

    context "when user's passive trades do not include required trade" do
      let(:params) { { api_token: user.token, trade_id: trade.id + 1 } }

      include_examples "returns the error not_found"
    end

    context "when required trade's status is not waiting_for_accept" do
      let(:trade) { create(:trade, buyer_id: buyer.id, seller_id: user.id, status: 2) }

      include_examples "returns the error unprocessable_entity"
    end
  end
end

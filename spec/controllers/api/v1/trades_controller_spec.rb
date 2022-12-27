# frozen_string_literal: true

require "rails_helper"
require "shared_examples/trades"

RSpec.describe Api::V1::TradesController, type: :controller do
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

      it "returns the error" do
        send_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    include_examples "check user authenticate"
    include_examples "check seller availability"
    include_examples "check seller inventory availability"

    context "when all necessary params exist" do
      context "when all the params are valid" do
        it "creates new trade" do
          expect { send_request }.to change(Trade, :count).by(1)
        end

        it "returns success status" do
          send_request

          expect(response).to have_http_status(:success)
        end
      end

      context "when not all the params are valid" do
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

  describe "POST /decline" do
    subject(:send_request) { post :decline, params: params }

    let(:params) { { api_token: user.token, trade_id: trade.id } }
    let(:user) { create(:user) }
    let(:trade) { create(:trade, buyer_id: user.id, seller_id: seller.id) }
    let(:seller) { create(:user, name: "Seller", email: "seller@gmail.com") }

    include_examples "check user authenticate"

    it "changes the status" do
      send_request
      trade.reload

      expect(trade.status.to_sym).to eq(:declined_by_initiator)
    end

    context "when user does not have active trades" do
      let(:trade) { build_stubbed(:trade, buyer_id: user.id + 1) }

      it "returns the error" do
        send_request

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user's active trades do not include required trade" do
      let(:params) { { api_token: user.token, trade_id: trade.id + 1 } }

      it "returns the error" do
        send_request

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when required trade's status is not waiting_for_accept" do
      let(:trade) { create(:trade, buyer_id: user.id, seller_id: seller.id, status: 2) }

      it "returns the error" do
        send_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"
require "shared_examples/trades"

RSpec.describe Api::V1::TradesController, type: :controller do
  describe "POST /create" do
    subject(:send_request) { post :create, params: params }

    shared_examples "does not create new trade and returns the error" do
      it "does not create new trade" do
        expect { send_request }.not_to change(Trade, :count)
      end

      it "returns the error" do
        send_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

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
    let(:user) { build_stubbed(:user) }
    let(:seller) { create(:user) }
    let(:seller_inventory) { create(:inventory, user: seller) }

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
end

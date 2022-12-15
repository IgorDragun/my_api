# frozen_string_literal: true

shared_examples_for "check item availability" do
  context "when the item does not exist" do
    let(:params) { { api_token: user.token, shop_id: shop.id, item_id: item.id + 1 } }

    it "returns the error" do
      send_request

      expect(response).to have_http_status(:not_found)
    end
  end
end

shared_examples_for "check item buy availability" do
  context "when the item can not be bought" do
    it "does not reduce the user balance" do
      expect { send_request }.not_to change(user, :balance)
    end

    it "does not reduce the item count" do
      send_request
      item.reload

      expect(item.count).not_to eq(item_count - 1)
    end

    it "does not increase the user inventories count" do
      expect { send_request }.not_to change(user.inventories, :count)
    end
  end
end

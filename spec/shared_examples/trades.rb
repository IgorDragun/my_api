# frozen_string_literal: true

shared_examples_for "check seller availability" do
  context "when the seller does not exist" do
    before do
      allow(controller).to receive(:authenticate!).and_return(user)
      allow(User).to receive(:find_by).with(id: params[:trade][:seller_id]).and_return(nil)
    end

    it "returns the error" do
      send_request

      expect(response).to have_http_status(:not_found)
    end
  end
end

shared_examples_for "check seller inventory availability" do
  context "when the seller inventory does not exist" do
    let(:params) do
      {
        api_token: user.token,
        trade: {
          seller_id: seller.id,
          seller_inventory_id: seller_inventory.id + 1,
          offered_price: 10.00
        }
      }
    end

    it "returns the error" do
      send_request

      expect(response).to have_http_status(:not_found)
    end
  end
end

# frozen_string_literal: true

shared_examples_for "check shop availability" do
  context "when the shop does not exist" do
    before do
      allow(Shop).to receive(:find_by).with(id: params[:shop_id]).and_return(nil)
    end

    it "returns the error" do
      send_request

      expect(response).to have_http_status(:not_found)
    end
  end
end

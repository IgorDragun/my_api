# frozen_string_literal: true

shared_examples_for "testing user authenticate" do
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

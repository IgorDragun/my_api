# frozen_string_literal: true

require "rails_helper"
require "shared_examples/authenticate"

RSpec.describe Api::V1::ShopsController, type: :controller do
  describe "GET/ index" do
    subject(:send_request) { get :index, params: params }

    before do
      allow(User).to receive(:find_by).with(token: params[:api_token]).and_return(user)
    end

    let(:params) { { api_token: user.token } }
    let(:user) { create(:user) }
    let!(:shop) { create(:shop) }
    let(:result) { { shops: [shop] } }

    include_examples "testing user authenticate"

    it "returns the list of shops" do
      send_request

      expect(response.body).to eq(result.to_json)
    end
  end
end

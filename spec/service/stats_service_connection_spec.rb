# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatsServiceConnection, type: :service do
  subject(:stats_service_connection) { described_class.new }

  let(:api_key) { "abc123" }
  let(:api_url) { "http://localhost:8080" }
  let(:item) { build_stubbed(:item) }

  before do
    ENV["STAT_SERVICE_API_KEY"] = api_key
    ENV["STAT_SERVICE_URL"] = api_url
  end

  describe "#initialize" do
    it "sets the token from the environment variable" do
      expect(stats_service_connection.token).to eq(api_key)
    end

    it "creates a new Faraday connection with the correct URL" do
      expect(stats_service_connection.connection.url_prefix.to_s).to eq("#{api_url}/")
    end
  end

  describe "#send_get" do
    let(:response_body) { [[1, 3]] }

    before do
      stub_request(:get, "#{api_url}/get_stats")
        .with(body: { api_token: api_key }.to_json, headers: { "Content-Type" => "application/json" })
        .to_return(status: 200, body: response_body.to_json)
    end

    it "responds with success" do
      response = stats_service_connection.send_get

      expect(response.status).to eq(200)
    end

    it "responds with correct body" do
      response = stats_service_connection.send_get

      expect(JSON.parse(response.body)).to eq(response_body)
    end
  end

  describe "#send_post" do
    before do
      stub_request(:post, "#{api_url}/log_stat")
        .with(body: { api_token: api_key, item_id: item.id }.to_json, headers: { "Content-Type" => "application/json" })
        .to_return(status: 200)
    end

    it "responds with success" do
      response = stats_service_connection.send_post(item_id: item.id)

      expect(response.status).to eq(200)
    end
  end
end

# frozen_string_literal: true

class StatsServiceConnection
  HEADER = { "Content-Type" => "application/json" }.freeze

  def initialize
    @token = ENV.fetch("STAT_SERVICE_API_KEY")
    @connection = Faraday.new(url: ENV.fetch("STAT_SERVICE_URL").to_s, headers: HEADER)
  end

  attr_reader :token, :connection

  def send_get
    connection.get("/get_stats") do |request|
      request.body = { api_token: token }.to_json
    end
  end

  def send_post(options = {})
    connection.post("/log_stat") do |request|
      request.body = { api_token: token }.merge(options).to_json
    end
  end
end

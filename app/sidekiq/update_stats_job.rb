# frozen_string_literal: true

class UpdateStatsJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    StatsServiceConnection.new.send_post(item_id: item_id)
  end
end

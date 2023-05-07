# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateStatsJob, type: :job do
  describe "#perform" do
    subject(:job) { described_class }

    let(:connection) { instance_double(StatsServiceConnection) }
    let(:item) { build_stubbed(:item) }

    before do
      allow(StatsServiceConnection).to receive(:new).and_return(connection)
      allow(connection).to receive(:send_post).with(item_id: item.id)

      job.perform_now(item.id)
    end

    it "creates connection and calls sends_post", :aggregate_failures do
      expect(StatsServiceConnection).to have_received(:new)
      expect(connection).to have_received(:send_post).with(item_id: item.id)
    end
  end
end

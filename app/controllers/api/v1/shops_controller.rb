# frozen_string_literal: true

class Api::V1::ShopsController < BaseController
  def index
    @shops = Shop.all

    api_response({ shops: @shops })
  end
end

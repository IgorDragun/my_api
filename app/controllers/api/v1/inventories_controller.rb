# frozen_string_literal: true

class Api::V1::InventoriesController < BaseController
  def index
    @inventories = @user.inventories

    api_response({ inventories: @inventories })
  end
end

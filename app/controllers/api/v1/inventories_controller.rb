class Api::V1::InventoriesController < ApplicationController
  def index
    @inventories = @user.inventories

    render json: { status: "success", inventories: @inventories }
  end
end

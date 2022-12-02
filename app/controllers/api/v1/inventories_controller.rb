class Api::V1::InventoriesController < ApplicationController
  before_action :authenticate!

  def index
    @inventories = @user.inventories

    render json: { status: "success", inventories: @inventories }
  end
end

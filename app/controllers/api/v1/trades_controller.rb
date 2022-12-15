# frozen_string_literal: true

class Api::V1::TradesController < BaseController
  before_action :find_seller, only: :create
  before_action :find_seller_inventory, only: :create
  def create
    @trade = Trade.new(trade_params)

    if @trade.save
      api_response(trade_info: @trade)
    else
      api_response(errors: @trade)
    end
  end

  private

  def find_seller
    @seller = User.find_by(id: permitted_params[:seller_id].to_i)

    raise ApiExceptions::SellerNotFound unless @seller
  end

  def find_seller_inventory
    @inventory = @seller.inventories.find_by(id: permitted_params[:seller_inventory_id].to_i)

    raise ApiExceptions::InventoryNotFound unless @inventory
  end

  def trade_params
    permitted_params.merge({ buyer_id: @user.id })
  end

  def permitted_params
    params.require(:trade).permit(:seller_id, :seller_inventory_id, :offered_price)
  end
end

# frozen_string_literal: true

class Api::V1::ItemsController < BaseController
  before_action :set_shop
  before_action :set_items
  before_action :set_item, only: %i[show buy_item]

  def index
    api_response(items: @items)
  end

  def show
    api_response(item: @item)
  end

  def buy_item
    result = complete_purchase

    render json: { status: "success", messages: "Item was bought" } if result
    render json: { status: "failure", messages: "Something was wrong" } unless result

  end

  private

  def set_shop
    @shop = Shop.find_by(id: params[:shop_id].to_i)

    raise ApiExceptions::ShopNotFound unless @shop
  end

  def set_items
    @items = @shop.items
  end

  def set_item
    raise ApiExceptions::ItemsNotFound if @items.blank?

    @item = @items.find_by(id: params[:item_id])

    raise ApiExceptions::ItemNotFound unless @item
  end

  def complete_purchase
    if item_count_positive? && enough_user_balance?
      perform_transaction
    else
      return { json: { status: "failure", error: "Not enough money" }, status: :unprocessable_entity } unless enough_user_balance?
      return { json: { status: "failure", error: "Not enough items" }, status: :unprocessable_entity } unless item_count_positive?
    end
  end

  def item_count_positive?
    @item.positive?
  end

  def enough_user_balance?
    @user.enough_balance?(@item.price)
  end

  def perform_transaction
    ActiveRecord::Base.transaction do
      @user.withdrawal(@item.price)
      @item.reduction
    end
  end
end

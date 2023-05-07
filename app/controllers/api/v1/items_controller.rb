# frozen_string_literal: true

class Api::V1::ItemsController < BaseController
  before_action :set_shop, except: :statistic
  before_action :set_items, except: :statistic
  before_action :set_item, only: %i[show buy_item]

  def index
    api_response(items: @items)
  end

  def show
    api_response(item: @item)
  end

  def buy_item
    check_user_balance
    check_item_count

    result = perform_transaction

    if result
      update_statistic

      api_response(message: I18n.t("messages.items.item_was_bought"))
    else
      api_response(message: I18n.t("messages.something_was_wrong"))
    end
  end

  def statistic
    response_data = statistic_data

    api_response(items: build_items_data(response_data))
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

    @item = @items.find_by(id: params[:item_id].to_i)

    raise ApiExceptions::ItemNotFound unless @item
  end

  def check_user_balance
    raise ApiExceptions::NotEnoughMoney if @user.balance < @item.price
  end

  def check_item_count
    raise ApiExceptions::NotEnoughItems unless @item.count.positive?
  end

  def perform_transaction
    ActiveRecord::Base.transaction do
      @user.withdrawal(@item.price)
      @item.count_reduce
      @user.inventories.create!(name: @item.name, cost: @item.price)
      true

    rescue StandardError
      false
    end
  end

  def update_statistic
    UpdateStatsJob.perform_later(@item.id)
  end

  def statistic_data
    connection = StatsServiceConnection.new
    connection.send_get
  end

  def build_items_data(data)
    items_data = JSON.parse(data.body.chomp)
    items_data.map { |inner_array| { id: inner_array[0], count: inner_array[1] } }
  end
end

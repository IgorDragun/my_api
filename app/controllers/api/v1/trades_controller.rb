# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class Api::V1::TradesController < BaseController
  before_action :find_seller_inventory, only: :create
  before_action :find_all_active_trades_by_user, only: %i[active_trades cancel]
  before_action :find_required_active_trade_by_user, only: :cancel
  before_action :find_all_passive_trades_by_user, only: %i[passive_trades accept decline]
  before_action :find_required_passive_trade_by_user, only: %i[accept decline]

  def create
    trade = Trade.new(trade_params)

    if trade.save
      api_response(trade_info: trade)
    else
      api_response(errors: trade.errors)
    end
  end

  def active_trades
    api_response(active_trades: @active_trades)
  end

  def passive_trades
    api_response(passive_trades: @passive_trades)
  end

  def accept
    check_trade_status!(:accept)
    check_inventory_presence!
    check_buyer_balance!
    result = perform_transaction

    if result
      api_response(message: I18n.t("messages.trades.trade_was_accepted"))
    else
      api_response(message: I18n.t("messages.something_was_wrong"))
    end
  end

  def cancel
    check_trade_status!(:cancel)

    if @active_trade.update(status: 4)
      api_response(message: I18n.t("messages.trades.trade_was_canceled"))
    else
      api_response(message: I18n.t("messages.something_was_wrong"))
    end
  end

  def decline
    check_trade_status!(:decline)

    if @passive_trade.update(status: 3)
      api_response(message: I18n.t("messages.trades.trade_was_declined"))
    else
      api_response(message: I18n.t("messages.something_was_wrong"))
    end
  end

  private

  def check_trade_status!(action)
    case action
    when :cancel
      raise ApiExceptions::TradeCanNotBeCanceled if @active_trade.status.to_sym != :waiting_for_accept
    when :decline
      raise ApiExceptions::TradeCanNotBeDeclined if @passive_trade.status.to_sym != :waiting_for_accept
    when :accept
      raise ApiExceptions::TradeCanNotBeAccepted if @passive_trade.status.to_sym != :waiting_for_accept
    else
      raise ApiExceptions::CommonError
    end
  end

  def check_inventory_presence!
    @user_inventory ||= @user.inventories.find_by(id: @passive_trade.seller_inventory_id)

    raise ApiExceptions::InventoryNotFound unless @user_inventory
  end

  def check_buyer_balance!
    @buyer ||= User.find_by(id: @passive_trade.buyer_id)

    raise ApiExceptions::UserNotFound unless @buyer
    raise ApiExceptions::BuyerDoesNotHaveEnoughMoney if @buyer.balance < @passive_trade.offered_price
  end

  def perform_transaction
    ActiveRecord::Base.transaction do
      @buyer.withdrawal(@passive_trade.offered_price)
      @user.deposit(@passive_trade.offered_price)
      @user_inventory.change_owner(@buyer, @passive_trade.offered_price)
      @passive_trade.update!(status: 2)
      true

    rescue StandardError
      false
    end
  end

  def find_seller_inventory
    seller = User.find_by(id: permitted_params[:seller_id].to_i)

    raise ApiExceptions::SellerNotFound unless seller

    seller_inventory = seller.inventories.find_by(id: permitted_params[:seller_inventory_id].to_i)

    raise ApiExceptions::InventoryNotFound unless seller_inventory
  end

  def find_all_active_trades_by_user
    @active_trades = @user.active_trades

    raise ApiExceptions::ActiveTradesDoNotExist if @active_trades.blank?
  end

  def find_required_active_trade_by_user
    @active_trade = @active_trades.find_by(id: params[:trade_id].to_i)

    raise ApiExceptions::TradeNotFound unless @active_trade
  end

  def find_all_passive_trades_by_user
    @passive_trades = @user.passive_trades

    raise ApiExceptions::PassiveTradesDoNotExist if @passive_trades.blank?
  end

  def find_required_passive_trade_by_user
    @passive_trade = @passive_trades.find_by(id: params[:trade_id].to_i)

    raise ApiExceptions::TradeNotFound unless @passive_trade
  end

  def trade_params
    permitted_params.merge({ buyer_id: @user.id })
  end

  def permitted_params
    params.require(:trade).permit(:seller_id, :seller_inventory_id, :offered_price)
  end
end
# rubocop:enable Metrics/ClassLength

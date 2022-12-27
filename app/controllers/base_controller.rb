# frozen_string_literal: true

class BaseController < ApplicationController
  before_action :authenticate!

  rescue_from ApiExceptions::CommonError, with: :respond_with_exception
  rescue_from ApiExceptions::UserNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::ShopNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::ItemsNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::ItemNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::NotEnoughMoney, with: :respond_with_exception
  rescue_from ApiExceptions::NotEnoughItems, with: :respond_with_exception
  rescue_from ApiExceptions::ItemAlreadyBought, with: :respond_with_exception
  rescue_from ApiExceptions::SellerNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::InventoryNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::ActiveTradesDoNotExist, with: :respond_with_exception
  rescue_from ApiExceptions::PassiveTradesDoNotExist, with: :respond_with_exception
  rescue_from ApiExceptions::TradeNotFound, with: :respond_with_exception
  rescue_from ApiExceptions::TradeCanNotBeCanceled, with: :respond_with_exception
  rescue_from ApiExceptions::TradeCanNotBeDeclined, with: :respond_with_exception

  def api_response(object)
    status = object.key?(:error) || object.key?(:errors) ? :unprocessable_entity : :ok

    response_data = { json: object.as_json, status: status }

    render response_data
  end

  private

  def authenticate!
    @user = User.find_by(token: params[:api_token])

    raise ApiExceptions::UserNotFound unless @user
  end

  def respond_with_exception(exception)
    data = response_data(exception)

    render json: { error: data[:message] }, status: data[:status]
  end

  def response_data(exception)
    exception_name = exception.to_s.underscore.split("/").last
    message = I18n.t("exceptions.#{exception_name}.message")
    status = I18n.t("exceptions.#{exception_name}.status")

    { message: message, status: status }
  end
end

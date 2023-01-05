# frozen_string_literal: true

class BaseController < ApplicationController
  before_action :authenticate!

  rescue_from ApiExceptions::BaseExceptions, with: :respond_with_exception

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

# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate!

  private

  def authenticate!
    @user = User.find_by(token: params[:api_token])

    render json: { status: 'failure', error: 'User does not exist' } unless @user
  end
end

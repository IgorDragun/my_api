# frozen_string_literal: true

class Api::V1::UsersController < BaseController
  skip_before_action :authenticate!

  def create
    user = User.new(user_params)

    if user.save
      api_response({ api_token: user.token })
    else
      api_response({ errors: user.errors })
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :balance)
  end
end

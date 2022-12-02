class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { status: "success", api_token: @user.token }
    else
      render json: { status: "failure", errors: @user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :balance)
  end
end

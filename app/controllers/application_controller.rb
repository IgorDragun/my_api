class ApplicationController < ActionController::API
  private

  def authenticate!
    @user = User.find_by(token: params[:api_token])

    render json: { status: "failure", error: "User does not exist" } unless @user
  end
end

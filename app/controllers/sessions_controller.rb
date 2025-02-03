class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      render json: { data: { token: Current.session.token } }
    else
      render json: {}, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    render json: { message: "Successfully logged out" }, status: :ok
  end
end

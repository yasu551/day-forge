class UserPasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    user_credential = UserCredential.find_by(email_address: params[:email_address])
    if user_credential
      UserPasswordsMailer.reset(user_credential).deliver_later
    end

    redirect_to new_user_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_user_session_path, notice: "Password has been reset."
    else
      redirect_to edit_user_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private

  def set_user_by_token
    user_credential = UserCredential.find_by_password_reset_token!(params[:token])
    @user = user_credential.user
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_user_password_path, alert: "Password reset link is invalid or has expired."
  end
end

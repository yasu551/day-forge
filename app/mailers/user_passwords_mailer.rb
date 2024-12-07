class UserPasswordsMailer < ApplicationMailer
  def reset(user_credential)
    @user_credential = user_credential
    mail subject: "Reset your password", to: @user_credential.email_address
  end
end

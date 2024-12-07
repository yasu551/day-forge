# Preview all emails at http://localhost:3000/rails/mailers/passwords_mailer
class UserPasswordsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/passwords_mailer/reset
  def reset
    UserPasswordsMailer.reset(UserCredential.take)
  end
end

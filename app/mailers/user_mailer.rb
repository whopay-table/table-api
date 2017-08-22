class UserMailer < ApplicationMailer
  default from: 'do-not-reply@whopay.com'

  def reset_password(group, user, password)
    @group = group
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Your password has been reset.')
  end
end

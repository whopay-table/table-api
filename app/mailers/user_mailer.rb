class UserMailer < ApplicationMailer
  default from: 'do-not-reply@whopay.com'

  def reset_password(group, user, password)
    @group = group
    @user = user
    @password = password
    # mail(to: @user.email, subject: 'Your password has been changed.')
    mail(to: 'jmbyun91@gmail.com', subject: 'Your password has been changed.')
  end
end

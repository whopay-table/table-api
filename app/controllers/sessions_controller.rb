class SessionsController < ApplicationController
  skip_before_action :auth, :only => [:signin]

  # POST /groups/1/login
  def login
    @user = User.authenticate(params.require(:group_id), params.require(:email), params.require(:password))
    if @user
      @session = Session.login(@user)
      render json: { token: @session.token }
    else
      render_invalid_params ['group_id', 'email', 'password']
    end
  end

  # POST /groups/1/logout
  def logout
    @current_session.destroy
  end
end

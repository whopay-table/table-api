class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :auth

  protected

  # Authenticate the user with token based authentication
  def auth
    auth_token || render_unauthorized
  end

  def auth_token
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(:api_key => token)
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: {
      :errors => [ { :code => "auth_fail", :message => "Authentication fail" } ]
    }, status: :unauthorized
  end
end

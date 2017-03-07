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

  def render_unauthorized(realm = 'Application')
    self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, '')}")
    render json: {
      errors: [ { code: 'auth_fail', message: 'Authentication fail' } ]
    }, status: :unauthorized
  end

  def render_forbidden
    render json: {
      errors: [ { code: 'forbidden', message: 'No access permission' } ]
    }, status: :forbidden
  end

  def render_invalid_params(keys)
    errors = []
    keys.each do |key|
      errors.push({
        code: 'invalid_param',
        key: key,
        message: %(Parameter "#{key}" is invalid)
      })
    end
    render json: { errors: errors }, status: :unprocessable_entity
  end
end

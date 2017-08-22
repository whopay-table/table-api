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
      @current_session = Session.authenticate(token)
      if @current_session
        @current_user = @current_session.user
      else
        nil
      end
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

  def render_model_errors(model_errors)
    errors = []
    model_errors.each do |key, messages|
      errors.push({
        code: 'model_error',
        key: key,
        messages: messages
      })
    end
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def render_succeed
    render json: { result: 'succeed' }
  end
end

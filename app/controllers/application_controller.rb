class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_cors_headers
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:4200'
    headers['Access-Control-Allow-Credentials'] = 'true'
  end
end

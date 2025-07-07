class ApplicationController < ActionController::Base
  # Skip CSRF for API routes completely
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :api_request?

  before_action :set_cors_headers
  before_action :configure_permitted_parameters, if: :devise_controller?

  def options
    head :ok
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
  end

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:4200'
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, X-Requested-With, X-CSRF-Token'

    # Handle preflight requests
    if request.request_method == 'OPTIONS'
      headers['Access-Control-Max-Age'] = '1728000'
      render plain: '', status: 200
    end
  end

  def api_request?
    request.path.starts_with?('/api/')
  end
end

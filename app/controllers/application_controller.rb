class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_cors_headers
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:4200'
    headers['Access-Control-Allow-Credentials'] = 'true'
  end
end

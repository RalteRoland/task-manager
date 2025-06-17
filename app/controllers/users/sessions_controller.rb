class Users::SessionsController < Devise::SessionsController
  # protect_from_forgery with: :null_session  # disable CSRF for API calls
  skip_before_action :verify_authenticity_token


  def create
    Rails.logger.info "Login params: #{params.inspect}"  # Log incoming params for debugging

    user = User.find_by(email: params.dig(:user, :email))
    password = params.dig(:user, :password)

    if user && user.valid_password?(password)
      sign_in(user)
      render json: { message: "Logged in successfully", user: { email: user.email, id: user.id } }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    sign_out(current_user)
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end

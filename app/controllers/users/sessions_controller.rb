class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])

    if user
      sign_in(user)
      redirect_to root_path, notice: "Logged in successfully with email only."
    else
      redirect_to new_user_session_path, alert: "Invalid email address."
    end
  end
end

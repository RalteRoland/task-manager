Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    sessions: "users/sessions"
  }

  # Add this line for the API endpoint
  get '/dashboard', to: 'dashboard#index'

  # Your existing routes...
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in")
  end

  resources :tasks
end

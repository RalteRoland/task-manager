Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }


  # Dashboard as the authenticated root (home page after login)
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  # Redirect unauthenticated users to the login page
  unauthenticated do
    root to: redirect("/users/sign_in")
  end

  # Resources for tasks with all CRUD routes
  resources :tasks

  # You can add other routes here as needed
end

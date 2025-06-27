Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: "users/sessions"
             }

  # ✅ All API routes grouped together
  namespace :api do
    get 'roles', to: 'roles#index'
    get 'dashboard', to: 'dashboard#index'
    resources :tasks
    resources :users, only: [:index]
    resources :subtasks, only: [:update]
    resources :comments, only: [:create]

    # Add other API routes here later (tasks, comments, etc.)
  end

  # 🔁 Root login routing
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in")
  end
end

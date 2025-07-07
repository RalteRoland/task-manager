Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: "users/sessions"
             }

  match '*path', to: 'application#options', via: :options

  # ✅ All API routes grouped together
  namespace :api do
    get "statuses/index"
    get 'roles', to: 'roles#index'
    get 'dashboard', to: 'dashboard#index'

    resources :tasks do
      member do
        patch :mark_complete   # 👈 custom route for marking a task as complete
      end
    end

    resources :users, only: [:index]
    resources :subtasks, only: [:update]
    resources :comments, only: [:create, :index, :destroy]
    resources :statuses, only: [:index]
    resources :priorities, only: [:index]

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

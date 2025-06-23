Rails.application.routes.draw do
  get "users/index"
  devise_for :users,
             controllers: {
               sessions: "users/sessions"
             }

  # API endpoint
  get '/dashboard', to: 'dashboard#index'


  get '/employees', to: 'users#index'


  # Routes for tasks
  resources :tasks

  # ✅ Add this line for updating a subtask's completion status
  resources :subtasks, only: [:update]

  resources :users, only: [:index]




  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in")
  end
end

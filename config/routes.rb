Rails.application.routes.draw do
  controller :sessions do
    post 'groups/:group_id/login', action: :login
    post 'groups/:group_id/logout', action: :logout
    get 'groups/:group_id/users/me', action: :show_current_user
  end
  controller :groups do
    post 'groups/:id/signup_key/reset', action: :reset_signup_key
    get 'groups/:id/signup_key', action: :show_signup_key
    post 'groups/:id/set_admin', action: :set_admin
  end
  controller :transactions do
    post 'groups/:group_id/transactions/:id/accept', action: :accept
    post 'groups/:group_id/transactions/:id/reject', action: :reject
    get 'groups/:group_id/users/:user_id/transactions', action: :index
  end
  resources :groups do
    resources :users
    resources :transactions
  end
end

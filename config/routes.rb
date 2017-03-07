Rails.application.routes.draw do
  resources :transactions
  controller :groups do
    post 'groups/:id/signup_key/reset', action: :reset_signup_key
    get 'groups/:id/signup_key', action: :show_signup_key
    post 'groups/:id/set_admin', action: :set_admin
  end
  resources :groups do
    resources :users
  end
end

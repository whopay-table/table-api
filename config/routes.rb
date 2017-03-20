Rails.application.routes.draw do
  controller :groups do
    post 'groups/:id/signup_key/reset', action: :reset_signup_key
    get 'groups/:id/signup_key', action: :show_signup_key
    post 'groups/:id/set_admin', action: :set_admin
  end
  controller :transactions do
    post 'groups/:group_id/transactions/:id/accept', action: :accept
    post 'groups/:group_id/transactions/:id/reject', action: :reject
  end
  end
  resources :groups do
    resources :users
    resources :transactions
  end
end

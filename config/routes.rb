Rails.application.routes.draw do
  resources :users

  controller :groups do
    post 'groups/:id/set_admin', action: :set_admin
  end
  resources :groups
end

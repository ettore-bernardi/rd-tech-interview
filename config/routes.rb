require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  post 'cart' => 'carts#create', as: :cart_create
  get 'cart' => 'carts#show', as: :cart_show

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'
end

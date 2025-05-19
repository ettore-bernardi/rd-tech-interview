require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  post 'cart' => 'carts#create', as: :cart_create

  get 'up' => 'rails/health#show', as: :rails_health_check

  root "rails/health#show"
end

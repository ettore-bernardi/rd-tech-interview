require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  post 'cart' => 'carts#create', as: :cart_create
  post 'cart/add_item' => 'carts#add_item', as: :cart_add_item
  get 'cart' => 'carts#show', as: :cart_show
  delete 'cart/:product_id' => 'carts#destroy', as: :cart_destroy

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'
end

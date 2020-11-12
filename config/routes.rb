# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'
  resources :charges
  resources :customers do
    post :add_card
    post :remove_card
  end
  resources :refunds
  resources :subscriptions, except: %i[edit update]
  get 'webhook', to: 'webhook#index'
  post 'webhook', to: 'webhook#endpoint'
end

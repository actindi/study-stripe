Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :charges
  resources :refunds
  resources :customers do
    post :add_card
    post :remove_card
  end
end

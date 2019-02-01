Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  resources :charges
  resources :refunds
  resources :customers do
    post :add_card
  end
end

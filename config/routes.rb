Rails.application.routes.draw do
  devise_for :managers
  resources :managers, only: [:new, :create]
  resources :condos, only: [:new, :create, :show]
  root to: "home#index"
end

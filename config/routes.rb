Rails.application.routes.draw do
  devise_for :managers
  resources :managers, only: [:new, :create]
  resources :condos, only: [:new, :create, :show, :edit, :update]
  resources :unit_types, only: [:new, :create, :show, :edit, :update]
  root to: "home#index"
end

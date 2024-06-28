Rails.application.routes.draw do

  resources :condos, only: [:new, :create, :show, :edit, :update] do
    resources :towers, only: [:new, :create]
  end

  devise_for :managers
  resources :managers, only: [:new, :create]

  resources :towers, only: [:show]
  resources :unit_types, only: [:new, :create, :show, :edit, :update]

  root to: "home#index"

  get '/signup_choice', to: 'home#signup'
end

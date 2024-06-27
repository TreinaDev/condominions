Rails.application.routes.draw do

  resources :condos, only: [:new, :create, :show] do
    resources :towers, only: [:new, :create]
  end

  resources :towers, only: [:show]
  resources :unit_types, only: [:new, :create, :show, :edit, :update]

  root to: "home#index"
end

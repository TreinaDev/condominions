Rails.application.routes.draw do

  resources :condos, only: [:new, :create, :show] do
    resources :towers, only: [:new, :create]
  end

  resources :towers, only: [:show]

  root to: "home#index"
end

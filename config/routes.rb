Rails.application.routes.draw do

  resources :condos, only: [:new, :create, :show, :edit, :update] do
    resources :towers, only: [:new, :create] do
      member do
        get :edit_floor_units
        patch :update_floor_units
      end
    end
  end

  devise_for :managers
  resources :managers, only: [:new, :create]

  resources :towers, only: [:show]
  resources :unit_types, only: [:new, :create, :show, :edit, :update]

  root to: "home#index"
end

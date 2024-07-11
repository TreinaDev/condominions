Rails.application.routes.draw do
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'

  devise_for :managers
  devise_for :residents
  resources :managers, only: [:new, :create]

  resources :residents, only: [:new, :create, :update] do
    resources :tenants, only:[:new, :create], on: :collection
    resources :owners, only:[:new, :create, :destroy], on: :collection
    get 'find_towers', on: :collection
    get 'confirm', on: :member
    get 'edit_photo', on: :member
    patch 'update_photo', on: :member
  end

  resources :common_areas, only: [:show, :edit, :update]

  resources :condos, only: [:new, :create, :show, :edit, :update] do
    resources :common_areas, only: [:index, :new, :create]
    resources :unit_types, only: [:index, :new, :create, :show, :edit, :update]

    resources :towers, only: [:new, :create, :index] do
      member do
        get :edit_floor_units
        patch :update_floor_units
      end
    end
  end

  resources :towers, only: [:show] do
    resources :floors, only: [:show] do
      resources :units, only: [:show]
    end
  end

  namespace :api do
    namespace :v1 do
      get 'check_registration_number', to: 'residents#check_registration_number'
      resources :condos, only: [:index, :show] do
        resources :unit_types, only: [:index]
      end
    end
  end
end

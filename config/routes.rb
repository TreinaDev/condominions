Rails.application.routes.draw do
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'

  devise_for :managers
  resources :managers, only: [:new, :create]
  resources :common_areas, only: [:show, :edit, :update]
  resources :unit_types, only: [:new, :create, :show, :edit, :update]

  resources :condos, only: [:index, :new, :create, :show, :edit, :update] do
    resources :common_areas, only: [:index, :new, :create]

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
end

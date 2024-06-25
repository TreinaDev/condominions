Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :condos, only: [:new, :create, :show]
  resources :unit_types, only: [:new, :create, :show]
  root to: "home#index"
end

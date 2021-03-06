Rails.application.routes.draw do

  
  root to: "home#index"
  #devise_for :users
  #devise_for :customers
  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions",
    :passwords => "users/passwords",
    :confirmations => "users/confirmations",
    :invitations => "users/invitations"
  }

  devise_for :customers, :controllers => {
    :registrations => "customers/registrations",
    :sessions => "customers/sessions",
    :passwords => "customers/passwords",
    :confirmations => "customers/confirmations",
    :omniauth_callbacks => "customers/omniauth_callbacks"
  }
  post '/auth/:provider/callback', to: 'sessions#create'

  devise_scope :user do
    authenticated :user do
      namespace :users do
        get 'home/index', as: :authenticated_root
      end
    end
  end

  devise_scope :customer do
    authenticated :customer do
      namespace :customers do
        get 'home/index', as: :authenticated_root
      end
    end
  end
  resources :products
  resources :companies
  get "companies-list", to: "companies#list"
  get "employees", to: "companies#employee"
  get 'search', to: "products#search"

  get "my-products", to: "products#my_product"
  #resources :checkout, only: [:create]
  post "checkout/create", to: "checkout#create"
  resources :webhooks, only: [:create]

  post "products/add_to_cart/:id", to: "products#add_to_cart", as: "add_to_cart"
  delete "products/remove_from_cart/:id", to: "products#remove_from_cart", as: "remove_from_cart"

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

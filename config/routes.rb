Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root "home#index"

  get "about", to: "home#about"
  get "/mypage", to: "users#show", as: :mypage
  get "contact", to: "contacts#new", as: "contact"
  resources :contacts, only: [ :new, :create ] do
    get "thank_you", on: :collection  # /contacts/thank_you を定義
  end
  resources :plans, only: [ :index, :show ]
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :gyms, only: [:index, :new, :create] do
    collection do
      get :import_from_google
    end
  end
  resources :tasks
  resources :supplements
  resources :proteins
  resources :weekly_menus, only: [ :index, :show ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end

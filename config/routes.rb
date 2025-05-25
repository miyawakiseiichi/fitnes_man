Rails.application.routes.draw do
  get "privacy_policies/show"
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations'
  }

  # OmniAuthのコールバックルートを明示的に定義
  devise_scope :user do
    get 'users/auth/google_oauth2/callback' => 'users/omniauth_callbacks#google_oauth2'
  end

  root "home#index"

  get "about", to: "home#about"
  get "/mypage", to: "users#show", as: :mypage
  get "contact", to: "contacts#new", as: "contact"
  resources :contacts, only: [ :new, :create ] do
    get "thank_you", on: :collection  # /contacts/thank_you を定義
  end
  resources :plans, only: [ :index, :show ]
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :gyms, only: [ :index, :new, :create ] do
    collection do
      get :import_from_google
    end
  end
  resources :tasks do
    member do
      patch :complete
      delete :destroy
    end
  end
  resources :supplements
  resources :proteins
  resources :weekly_menus, only: [ :index, :show ]

  get 'privacy_policy', to: 'privacy_policies#show', as: 'privacy_policy'

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

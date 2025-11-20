Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resources :organizations, only: [ :index, :edit, :update, :show ] do
    resources :invitations, only: [ :create, :destroy ], controller: "organizations/invitations" do
      post :resend, on: :member
    end
    resources :members, only: [ :index, :destroy, :edit, :update ], controller: "organizations/members"
  end

  get "invitations/:token/accept", to: "invitation_acceptances#new", as: :accept_invitation

  resources :projects do
    get "users/mentions", to: "users#mentions"
    get :settings, on: :member
    resources :members, only: [ :create, :edit, :update, :destroy ], controller: "projects/members"
    resources :webhooks, only: [ :index, :create, :edit, :update, :destroy ], controller: "projects/webhooks"
    resources :stories, only: [ :show, :update, :create, :new, :destroy ] do
      get :mentions, on: :collection
      get :search, on: :collection
      patch :move, on: :member
      patch :autosave, on: :member

      resources :comments, only: [ :update, :create, :new, :destroy, :edit, :show ]
    end

    resources :documents, only: [ :index, :show, :update, :create, :new, :edit, :destroy ] do
      get :mentions, on: :collection
      get :search, on: :collection
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :user, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  authenticated :user do
    # root "app#index", as: :authenticated_root
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # root "home#index"
  # TODO: uncomment above
  resources :subscriptions, only: [ :new, :create ]
  resource :docs, only: [ :show ]
  root "subscriptions#new"

  namespace :api do
    post "webhooks/:token", to: "webhooks#create", as: :webhook
  end
end

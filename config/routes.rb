Rails.application.routes.draw do
  resources :iterations, only: [:index] do
    resources :stories, only: [:new, :create], controller: 'iteration_stories'
  end

  resources :stories, only: [:new, :create]

  resource :user, only: [:show, :edit, :update]

  root to: 'vistors#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/login' => 'sessions#new', as: :login
  get '/logout' => 'sessions#destroy', as: :logout
  get '/auth/failure' => 'sessions#failure'
end

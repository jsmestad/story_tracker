Rails.application.routes.draw do
  get '/users', to: redirect('/admin/users')
  get '/stories', to: redirect('/admin/stories')
  ActiveAdmin.routes(self)
  resources :iterations, only: [:index] do
    resources :stories, only: [:new, :create], controller: 'iteration_stories'
  end

  resources :stories, except: [:index, :destroy] do
    collection do
      get 'search'
    end

    resource :follow, only: [:create, :destroy]
  end
  resources :defects, only: [:new, :create]

  # resource :user, only: [:show, :edit, :update]
  get '/account', to: 'users#show'

  resources :users, except: [:index]

  root to: 'vistors#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/login' => 'sessions#new', as: :login
  get '/logout' => 'sessions#destroy', as: :logout
  get '/auth/failure' => 'sessions#failure'

  namespace :pivotal_tracker do
    post 'callback', to: 'hooks#callback'
  end
end

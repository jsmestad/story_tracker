Rails.application.routes.draw do
  resources :iterations, only: [:index] do
    resources :stories, only: [:new, :create], controller: 'iteration_stories'
  end

  resources :stories, only: [:new, :create]

  root to: 'iterations#index'
end

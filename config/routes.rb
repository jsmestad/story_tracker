Rails.application.routes.draw do
  resources :iterations, only: [:index] do
    resources :stories, only: [:new, :create]
  end

  root to: 'iterations#index'
end

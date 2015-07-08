Rails.application.routes.draw do
  get '/iterations', to: 'iterations#index'
  root to: 'stories#index'
end

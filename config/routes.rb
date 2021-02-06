Rails.application.routes.draw do
  root 'static#index'

  namespace :api do
    resources :movies
  end

  # Catch-all for react-router-dom
  get '*path' => 'static#index'
end

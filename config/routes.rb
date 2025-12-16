# config/routes.rb
Rails.application.routes.draw do
  root "movies#index"
  resources :movies

  get "analytics/index"

  get "up" => "rails/health#show", as: :rails_health_check
end

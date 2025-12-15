Rails.application.routes.draw do
  root "movies#index"

  resources :movies

  get "analytics", to: "analytics#index"

  get "up" => "rails/health#show", as: :rails_health_check
end

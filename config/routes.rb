Rails.application.routes.draw do
  resources :movies
  get "analytics", to: "analytics#index"
  get "analytics/advanced", to: "analytics#advanced_analytics", as: "advanced_analytics"
  get "analytics/export", to: "analytics#index", format: "csv"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "movies#index"
end

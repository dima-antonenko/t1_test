# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "/weather/historical/min", to: "api/v1/accuweather#historical_min"
  get "/weather/historical/max", to: "api/v1/accuweather#historical_max"
  get "/weather/historical/avg", to: "api/v1/accuweather#historical_avg"

  get "/weather/current", to: "api/v1/accuweather#current"
  get "/weather/historical", to: "api/v1/accuweather#historical"
  get "/weather/by_time", to: "api/v1/accuweather#by_time"

  mount HealthBit.rack => "/health"
end

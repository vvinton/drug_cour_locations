require 'sidekiq/web'
# Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  mount Sidekiq::Web => '/admin/sidekiq'
  devise_for :users
  resources :dashboard
  resources :programs_information
  resources :imports
  namespace :api do
    namespace :v1 do

      get :metrics,      to: 'api#metrics'
      get :boundaries,   to: 'api#boundaries'
      get :color_legend, to: 'api#color_legend'
    end
  end
  get :state_coordinators, to: 'state_coordinators#index'
  get :bja,                to: 'bja#index'
  get :courts_by_type,     to: 'courts_by_type#index'
  root                     to: 'dashboard#index'
end

Rails.application.routes.draw do
  devise_for :users
  resources :dashboard
  resources :programs_information
  resources :ng_programs_information
  resources :imports
  namespace :api do
    namespace :v1 do

      get :metrics,      to: 'api#metrics'
      get :boundaries,   to: 'api#boundaries'
      get :color_legend, to: 'api#color_legend'
    end
  end
  get :nearbys,            to: 'programs_information#nearbys'
  get :statistic,          to: 'programs_information#statistic'
  get :state_coordinators, to: 'state_coordinators#index'

  get :courts_by_type,     to: 'courts_by_type#index'
  get :next,               to: 'ng_programs_information#index'
  get :list,               to: 'programs_information#index'
  root                     to: 'dashboard#index'
end

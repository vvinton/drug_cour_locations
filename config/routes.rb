Rails.application.routes.draw do
  devise_for :users
  resources :programs_information
  resources :imports
  namespace :api do
    namespace :v1 do
      get :states_by_type, to: 'api#states_by_type'
      get :states_by_color, to: 'api#states_by_color'
    end
  end
  get :nearbys, to: 'programs_information#nearbys'
  get :statistic, to: 'programs_information#statistic'
  get :state_coordinators, to: 'state_coordinators#index'
  get :courts_by_type, to: 'courts_by_type#index'
  root to: 'programs_information#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  devise_for :users
  resources :programs_information
  resources :imports
  get :nearbys, to: 'programs_information#nearbys'
  get :statistic, to: 'programs_information#statistic'
  get :state_coordinators, to: 'state_coordinators#index'
  get :courts_by_type, to: 'courts_by_type#index'
  root to: 'programs_information#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

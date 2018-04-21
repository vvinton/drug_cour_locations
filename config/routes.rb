Rails.application.routes.draw do
  devise_for :users
  resources :dashboard
  resources :programs_information
  resources :ng_programs_information
  resources :imports
  namespace :api do
    namespace :v1 do
<<<<<<< HEAD
      get :metrics, to: 'api#metrics'
      resources :courts_by_state, only: [:index, :show]
=======
      get :metrics,      to: 'api#metrics'
      get :boundaries,   to: 'api#boundaries'
      get :color_legend, to: 'api#color_legend'
>>>>>>> wf_next_gen
    end
  end
  get :nearbys,            to: 'programs_information#nearbys'
  get :statistic,          to: 'programs_information#statistic'
  get :state_coordinators, to: 'state_coordinators#index'
<<<<<<< HEAD
  get :courts_by_type, to: 'courts_by_type#index'
  get :next, to: 'ng_programs_information#index'
  root to: 'programs_information#index'
=======
  get :courts_by_type,     to: 'courts_by_type#index'
  get :next,               to: 'ng_programs_information#index'
  get :list,               to: 'programs_information#index'
  root                     to: 'dashboard#index'
>>>>>>> wf_next_gen
end

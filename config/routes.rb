Rails.application.routes.draw do
  get 'pages/index'
  root 'pages#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  namespace :admin do
    resources :users
  end

end

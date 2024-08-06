Rails.application.routes.draw do
  root 'organizations#index'
  resources :organizations, only: %i[new create]

  constraints subdomain: /.*/ do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }
  end
end

Rails.application.routes.draw do
  root 'organizations#index'
  resources :organizations, only: %i[new create]

  constraints subdomain: /.*/ do
    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
  end
end

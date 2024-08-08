Rails.application.routes.draw do
  root 'organizations#index'
  resources :organizations, only: %i[new create index] do
    collection do
      get 'login'
      post 'process_login'
    end
  end

  constraints subdomain: /.*/ do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
    resources :owners, only: %i[index]
    resources :user, only: %i[new create]
  end
end

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
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }
    resources :projects do
      member do
        post 'add_user'
      end
    end
    resources :owners, only: %i[index]
  end
end

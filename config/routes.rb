Rails.application.routes.draw do
  root 'organizations#index'

  resources :organizations, only: %i[new create index] do
    collection do
      get 'login'
      post 'process_login'
    end
  end

  constraints subdomain: /.*/ do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    resources :projects do
      member do
        post 'add_user'
      end
      resources :issues
    end

    resources :owners, only: %i[index]
    resources :user, only: %i[index new create edit update]
    resources :project_managers, only: %i[index]
    resources :admins, only: %i[index]
  end
end
Rails.application.routes.draw do
  root 'organizations#index'

  resources :organizations, only: %i[new create index] do
    collection do
      get 'render_login_form'
      post 'login_existing'
    end
  end

  constraints subdomain: /.*/ do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }
    resources :projects do
      member do
        post 'add_user'
      end
      resources :issues
    end

    resources :dashboards, only: %i[index]
    resources :user
  end
end

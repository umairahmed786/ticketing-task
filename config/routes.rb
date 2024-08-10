Rails.application.routes.draw do
  root 'organizations#index'

  resources :organizations, only: %i[new create index] do
    collection do
      get 'render_login_form'
      post 'login_existing'
    end
  end

  constraints subdomain: /.*/ do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    resources :projects do
      member do
        post 'add_user'
      end
      resources :issues do
        member do
          post 'attach_file' 
        end

        resources :comments
      end
    end

    resources :owners, only: %i[index]
    resources :user, only: %i[index new create edit update]
    resources :project_managers, only: %i[index]
    resources :admins, only: %i[index]
  end
end

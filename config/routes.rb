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
        delete 'remove_user'
      end
      resources :issues do
        member do
          post 'attach_file' 
        end

        resources :comments
      end
    end

    resources :dashboards, only: %i[index] do
      collection do
        post 'add_custom_state', to: 'dashboards#add_custom_state', as: 'custom_states'
      end
    end
    resources :user
  end
end

Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'organizations#index' # root path
    resources :organizations, only: :index do
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
        resources :issues, only: %i[index new create edit update destroy] do
          member do
            post 'attach_file'
          end
          resources :comments
        end
        resources :issues
      end

      resources :dashboards, only: %i[index] do
        collection do
          post 'add_custom_state', to: 'dashboards#add_custom_state', as: 'custom_states'
        end
      end
      resources :issues, only: %i[show index]

      resources :user do
        member do
          get 'edit_user_profile'
          match 'update_user_profile', via: %i[get post]
        end
      end
      get 'search', to: 'search#index'
    end

    # Exclude Active Storage routes from the catch-all
    # unless Rails.env.development? && ENV["DISABLE_PAGE_NOT_FOUND"]
    match '*path', to: 'errors#page_not_found', via: :all, constraints: lambda { |req|
      req.path.exclude?('/rails/active_storage/')
    }
  end
end

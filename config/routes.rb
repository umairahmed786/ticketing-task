Rails.application.routes.draw do
  root 'organizations#index' # root path
  resources :organizations, only: %i[new create index] do
    collection do
      get 'render_login_form'
      match 'login_existing', via: %i[get post]
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
    resources :user
    resources :issues, only: %i[show index]

    resources :dashboards, only: %i[index]
    resources :user do
      member do
        get 'edit_user_profile'
        match 'update_user_profile', via: %i[get post]
      end
    end
    get 'search', to: 'search#index'
  end
  # # Catch-all route for routing errors
  # match '*path', to: 'errors#page_not_found', via: :all
  # Exclude Active Storage routes from the catch-all
  # unless Rails.env.development? && ENV["DISABLE_PAGE_NOT_FOUND"]
    match '*path', to: 'errors#page_not_found', via: :all, constraints: lambda { |req|
      req.path.exclude?('/rails/active_storage/')
    }
  # end
end

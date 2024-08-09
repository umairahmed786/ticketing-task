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
      registrations: 'users/registrations'
    }
    resources :owners, only: %i[index]
  end
end

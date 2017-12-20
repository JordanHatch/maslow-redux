Maslow::Application.routes.draw do
  get "/healthcheck" => Proc.new { [200, {"Content-type" => "text/plain"}, ["OK"]] }

  devise_for :users,
          controllers: {
            passwords: 'passwords',
          },
          skip: [:sessions]

  as :user do
    get 'sign-in', to: 'sessions#new', as: :new_user_session
    post 'sign-in', to: 'sessions#create', as: :user_session
    get 'sign-out', to: 'sessions#destroy', as: :destroy_user_session
  end


  resources :bookmarks, only: [:index] do
    collection do
      post :toggle
    end
  end

  resources :needs, except: [:destroy] do
    resources :decisions, only: [:new, :create]
    resources :notes, only: :create
    resources :responses, controller: 'need_responses'
    resource :performance, controller: 'need_performance', only: :show

    resources :responses, controller: 'need_responses' do
      member do
        get '/performance/:metric_type/:date', to: 'need_performance_points#show', as: :performance_point
        put '/performance/:metric_type/:date', to: 'need_performance_points#update'
      end
    end

    member do
      patch :closed
      delete :closed, to: 'needs#reopen', as: :reopen
      get :close_as_duplicate, path: 'close-as-duplicate'

      get :activity
      get :evidence
    end
  end

  resource :user, only: [] do
    collection do
      get :password, to: 'user#edit_password', as: :edit_password
      put :password, to: 'user#update_password', as: :password
    end
  end

  namespace :settings do
    resources :tag_types, path: 'tag-types' do
      resources :tags
    end
    resources :users
    resources :bot_users, path: 'api-clients'

    root to: 'root#index'
  end

  root :to => redirect('/needs')
end

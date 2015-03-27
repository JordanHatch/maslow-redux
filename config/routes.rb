Maslow::Application.routes.draw do
  get "/healthcheck" => Proc.new { [200, {"Content-type" => "text/plain"}, ["OK"]] }

  devise_for :users,
          controllers: {
            sessions: 'sessions',
            passwords: 'passwords',
          }


  resources :bookmarks, only: [:index] do
    collection do
      post :toggle
    end
  end

  resources :needs, except: [:destroy] do
    resources :decisions
    resources :activity_items, path: 'activity', only: :index
    resources :notes, only: :create

    member do
      get :revisions
      patch :closed
      delete :closed, to: 'needs#reopen', as: :reopen
      get :close_as_duplicate, path: 'close-as-duplicate'
    end
  end

  namespace :settings do
    resources :tag_types, path: 'tag-types' do
      resources :tags
    end

    root to: 'root#index'
  end

  root :to => redirect('/needs')
end

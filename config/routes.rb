Maslow::Application.routes.draw do
  get "/healthcheck" => Proc.new { [200, {"Content-type" => "text/plain"}, ["OK"]] }

  resources :bookmarks, only: [:index] do
    collection do
      post :toggle
    end
  end

  resources :notes, only: [:create]

  resources :needs, except: [:destroy] do
    member do
      get :revisions
      patch :closed
      get :status
      patch :status, to: 'needs#update_status', as: 'update_status'
      delete :closed, to: 'needs#reopen', as: :reopen
      get :actions
      get :close_as_duplicate, path: 'close-as-duplicate'
    end
  end

  namespace :settings do
    root to: 'root#index'
  end

  root :to => redirect('/needs')
end

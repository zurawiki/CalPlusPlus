CalPlusPlus::Application.routes.draw do
  root :to => 'main#welcome'
  get 'home' => 'main#home'

  # resources :users, :only => [ :show, :edit, :update ]
  post '/oauth/request_token' => 'sessions#new'
  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'

  match '/login' => 'main#welcome'
  match '/logout' => 'sessions#destroy', :as => :logout

  match '/import' => 'import#list'
  get '/import/list'
  get '/import/calendar'
  get '/import/train'

  resources :events

end

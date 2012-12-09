CalPlusPlus::Application.routes.draw do

  get "home" => "main#home"

  root :to => 'main#welcome'

  # resources :users, :only => [ :show, :edit, :update ]

  post '/oauth/request_token' => 'sessions#new'

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'

  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout

  resources :events
  match '/import' => 'import#list'
  get "/import/list"
  get "/import/calendar"

end

Rails.application.routes.draw do

  root 'static#home'
  resources :users, only: [:create, :show]
  resource :session, only: [:create, :destroy]

  get "/auth/:provider/callback" => "sessions#create_from_omniauth"

  post '/compute-return' => "calculator#calculate"

  resources :portfolios

  get '/search' => 'search#search'

end

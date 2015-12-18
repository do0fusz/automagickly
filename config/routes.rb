Rails.application.routes.draw do
  root 'pages#welcome'

  resources :payment_methods, only: [:new] do 
  	get :confirmation, on: :collection 
  end

  resources :subscriptions, only: [:create]

  get "/sign_up" => "users#new", as: :sign_up
  post "/sign_up" => "users#create"

  get '/sign_in' => "sessions#new", as: :sign_in 
  post '/sign_in' => 'sessions#create' 
  get '/sign_out' => 'sessions#destroy', as: :sign_out 
end

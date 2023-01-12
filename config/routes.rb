Rails.application.routes.draw do
  resources :prueba_props

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/signup', to: "users#create"
  get '/profile', to: "users#show"
  patch '/update', to: "users#update"
  
  get '/properties', to: 'properties#index'
  post '/properties', to: 'properties#create'
  get '/properties/:id', to: 'properties#show'
  delete'/properties/:id', to: 'properties#destroy'
  patch '/properties/:id', to: 'properties#update'

  get '/involved_properties', to: 'involved_properties#index'
  post '/involved_properties', to: 'involved_properties#create'
  patch '/involved_properties/:id', to: 'involved_properties#update'
  
  get '/my_properties', to: 'involved_properties#get_properties'

  post '/login', to: 'sessions#create'
  delete'/logout', to: 'sessions#destroy'

end




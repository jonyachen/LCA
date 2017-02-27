Rails.application.routes.draw do

  resources :model
  resources :graph

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'model#index'
  match '/welcome' => 'users#welcome', via: :get
  match '/login' => 'users#login', via: [:get, :post]
  match '/logout' => 'users#logout', via: [:get, :post]
  match '/signup' => 'users#signup', via: [:get, :post]
  match '/profile' => 'users#profile', via: [:get, :post]
  match '/lca' => 'graphs#fetch_data', via: :get

end

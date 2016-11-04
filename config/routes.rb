Rails.application.routes.draw do
  resources :model

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'model#index'
  
end

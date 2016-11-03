Rails.application.routes.draw do
  get 'model/index'
  post'model/store'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'model#index'
  
end

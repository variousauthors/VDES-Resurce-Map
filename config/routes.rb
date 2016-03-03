GSWS204::Application.routes.draw do

  resources :services
  root to: 'services#index'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

end

GSWS204::Application.routes.draw do

  resources :services do
    collection do
      get 'print'
    end
  end
  root to: 'services#index'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

end

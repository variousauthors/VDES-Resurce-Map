GSWS204::Application.routes.draw do

  root to: 'pages#root'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

end

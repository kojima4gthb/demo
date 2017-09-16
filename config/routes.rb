Rails.application.routes.draw do
  resources :inputs
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get     'top',     to: 'top#new'
#  post    'top',    to: 'top#index'
  post    'top',     to: 'top#create'

  get     'login',   to: 'logins#new'
  post    'login',   to: 'logins#create'
  delete  'logout',  to: 'logins#destroy'

  get     'main',    to: 'contents#index'
#  post    'main',   to: 'contents#index'
end

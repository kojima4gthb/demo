Rails.application.routes.draw do
  resources :blogs do
    resources :entries do
      resources :comments do
        member do
          patch 'approve'
        end
      end
    end
  end

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get     'top',     to: 'top#new'
  #post    'top',    to: 'top#index'
  post    'top',     to: 'top#create'

  get     'login',   to: 'logins#new'
  post    'login',   to: 'logins#create'
  delete  'logout',  to: 'logins#destroy'

  get     'main',    to: 'contents#index'
  post    'tri',     to: 'contents#tri'
  post    'era',     to: 'contents#era'

  #patch '/blogs/:blog_id/entries/:entry_id/comments/:id/approve', to: 'comments#approve'
end

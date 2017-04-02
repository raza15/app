Rails.application.routes.draw do
  get 'sessions/new'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  root 'sessions#new'  
  get '/dropbox', to: 'dropbox#index'
  get '/search', to: 'dropbox#search'

  get "dropbox/index"

  get 'dropbox/authorize' => 'dropbox#authorize'
  # get 'dropbox/search' => 'dropbox#search'
  post 'dropbox/upload' => 'dropbox#upload'
  get 'dropbox/searchresult' => 'dropbox#searchresult'
  post 'dropbox/create_folder' => 'dropbox#create_folder'
  get 'dropbox/download_file' => 'dropbox#download_file', :as => :download_file
  get 'dropbox/delete_file' => 'dropbox#delete_file', :as => :delete_file  

  resources :users do
    member do
      get 'face_book'
      get 'twitter'
      get 'stack_overflow'
      get 'g_mail'
      get 'udp'
    end
  end  
 #  resources :dropbox do
 #    member do
	# get "dropbox/index" => 'dropbox#index'
	# get 'dropbox/authorize' => 'dropbox#authorize'
	# post 'dropbox/upload' => 'dropbox#upload'
	# post 'dropbox/create_folder' => 'dropbox#create_folder'
	# get 'dropbox/download_file' => 'dropbox#download_file', :as => :download_file
	# get 'dropbox/delete_file' => 'dropbox#delete_file', :as => :delete_file
 #    end
 #  end
end

Rails.application.routes.draw do
  root 'welcome#index'
  resources :songs
  get '/lyrics', action: 'lyrics', controller: 'songs'
  get '/test', action: 'test', controller: 'songs'
end

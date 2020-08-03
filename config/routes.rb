Rails.application.routes.draw do
  resources :songs
  get '/lyrics', action: 'lyrics', controller: 'songs'
end

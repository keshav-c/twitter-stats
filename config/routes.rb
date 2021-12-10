Rails.application.routes.draw do
  root "pages#home"
  
  get '/auth/auth0/callback', to: 'auth0#callback'
  get '/auth/failure', to: 'auth0#failure'
  get '/auth/logout', to: 'auth0#logout'

  get '/dashboard', to: 'dashboard#show'
end

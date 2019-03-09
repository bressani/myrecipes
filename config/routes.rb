Rails.application.routes.draw do
  root "pages#home"
  get 'pages/home', to: 'pages#home'
  get 'about', to: 'about#show'

  resources :recipes

  get 'signup', to: 'chefs#new'
  resources :chefs, except: [:new]
end

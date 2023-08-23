Rails.application.routes.draw do
  devise_for :users,controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :posts
  root 'posts#index'
  get 'about', to:'pages#about'

end

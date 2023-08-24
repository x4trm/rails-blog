Rails.application.routes.draw do
  devise_for :users,controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :posts
  resources :posts do
    resources :comments
  end
  root 'posts#index'
  get 'about', to:'pages#about' 
end

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "game", to: "games#show"

  resources :posts, only: [:show], path: "blog"

  namespace :admin do
    root "posts#index"

    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :posts
  end
end

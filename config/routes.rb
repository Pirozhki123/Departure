Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  root to: "public/homes#top"
  get "about" => "public/homes#about"

  namespace :admin do
    get "/" => "homes#top"
    resources :customer, only: [:index, :show, :edit, :update]
  end

  scope module: :public do
    resources :posts, only: [:index, :show, :edit, :new, :create, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources :customers, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      member do
        get "favorite_posts"
      end
    end

    get "search" => "searches#search"
  end



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
Rails.application.routes.draw do

  namespace :admin do
    resources :customer, only: [:index, :show, :edit, :update]
  end
  root to: 'public/homes#top'


  namespace :public do
    resources :posts, only: [:index, :show, :edit, :create, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
    end

    resources :customers, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers' => 'relationships#followers', as: 'followers'
        # member do
        #   # get 'favorite_posts'
        #   # get :followings
        #   # get :followers
        # end
      member do
        get 'favorite_posts'
      end
    end

    get "search" => "searches#search"
  end


  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
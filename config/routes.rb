Rails.application.routes.draw do

  namespace :admin do
    resources :customer, only: [:index, :show, :edit, :update]
  end
  root to: 'public/homes#top'

  namespace :public do
    resources :posts, only: [:index, :show, :edit, :create, :update, :destroy]
    get "search" => "searches#search"
  end

  namespace :public do
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
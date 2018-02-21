Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users, controllers: { registrations: "registrations"}

  resources :players do
    resources :games
  end

  resources :games

  resources :users 

  resources :drafts do
    member do
      patch 'nominate'
      patch 'unnominate'
      patch 'undo_drafting'
    end
  end

  resources :bids

  mount ActionCable.server, at: '/cable'

end

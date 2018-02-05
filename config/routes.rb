Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users, controllers: { registrations: "registrations"}

  resources :players do
    resources :games
  end

  resources :games
end

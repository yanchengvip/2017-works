Rails.application.routes.draw do

  root 'session#index'
  resources :accounts
  resources :dealers
  resources :wechat_users
  resources :users
  resources :session do
    collection do
      post :phone_login
      post :wechat_login
      post :send_verify_code
      post :forget_password
    end
  end
  resources :account_traders
  namespace :mt4 do
    resources :trades
    resources :fx_prices
  end
  namespace :virtual do
    resources :trades do
      collection do
        post :trade_close
      end
    end
  end

  mount ActionCable.server => '/cable'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

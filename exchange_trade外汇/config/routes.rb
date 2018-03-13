require 'sidekiq/web'
Rails.application.routes.draw do

  resources :exchange_product_price_notices
  resources :detections
  resources :images
  resources :areas
  resources :exchange_product_price_logs
  resources :exchange_products
  resources :wechat_accounts
  resource :wechat, only: [:show, :create]
  resources :adverts
  resources :account_medals
  resources :tactic_profits
  resources :account_tactics
  resources :financial_records, only: [:index] do
    collection do
      post :wisdom_financial_record
    end
  end
  resources :comments do
    member do
      get :like
      get :unlike
    end
  end
  resources :messages
  resources :medals

  resources :tactics
  resources :account_masters
  resources :booking_trades do
    collection do
      get :history_trades
    end
  end
  resources :trades do
    collection do
      post :trade_simple
      post :trade_copy
      post :trade_close
      get :master_order
      get :currency_max_min_price
    end
  end
  resources :accounts do
    collection do
      post :wisdom_external_account
      get :follow_list
      get :account_medals
      get :simulation_account
    end
    member do
      get :follow
      get :destroy_follow
      get :master_detail
    end
  end
  resources :dealers
  resources :users do
    collection do
      post :forget_password
      post :set_pay_password
      post :forget_pay_password
      post :reset_phone
      post :bind_phone
      post :reset_email
    end
  end

  resources :articles do
    member do
      get :like
      get :unlike
    end
  end
  resources :searchs


  namespace :wisdom do
    get :external_account_callback
    post :external_account_callback
    get :external_deposit_callback
    post :external_deposit_callback
    get :external_withdraw_callback
    post :external_withdraw_callback
  end
  post 'session/login'
  post 'session/wx_auth'
  post 'session/verify_phone_code'
  post 'session/verify_rucaptcha_phone_code'
  match '/login', to: 'session#login', via: [:get]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # mount RuCaptcha::Engine => "/rucaptcha"
  root "articles#index"

  mount Sidekiq::Web => '/sidekiq'
end

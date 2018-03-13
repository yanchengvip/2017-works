Rails.application.routes.draw do
  match  'data/common/files/753/get', to: "app_version#old", via: [:get, :post]
  resource :wechat, only: [:show, :create]
  match '/home', to: 'auction/pic_ads#index', via: [:get]
  match '/login', to: 'core/sessions#login', via: [:post]
  match '/sessions', to: 'core/sessions#current_time', via: [:get]
  match '/ad_seckill_theme', to: 'auction/pic_ads#ad_seckill_theme', via: [:get]
  match '/app_version/current', to: 'app_version#current', via: [:get]

  namespace :auction do
    resources :carousels, only: [:index]
    resources :themes, only: [:index, :show]
    resources :seckills, only: [:index]
    resources :trades, only: [:index, :show, :create] do
      member do
        post :cancel
      end
      collection do
        get :confirm_products_list
        get :delivery_query
        get :amounts
        get :pay_list
        post :express
        post :receive
      end
    end

    resources :units, only: [] do
      collection do
        post :return
        get :return_detail
      end
    end

  end

  namespace :pay do
    resources :paypals, only: [:create] do
      collection do
        post :execute
      end
    end
    resources :alipays, only: [:index, :new] do
      collection do
        post 'notify'
      end
    end
    resource :wechats do
      collection do
        get :pc_pay
        get :mobile_wx_pay
        get :mobile_pay
        get :app_pay
        post 'notify'

      end
    end
  end

  namespace :retail do
    resources :carts, only: [:index, :create] do
      collection do
        delete :destroy
      end
    end
  end

  namespace :auction do
    resources :voucher_trades do
      collection do
        get :voucher
        post :checkout
        get :alipay_notify
        post :alipay_notify
        post :execute
      end
      member do
        get :alipay_notify
        post :alipay_notify
        get :alipay_return
        post :alipay_return
      end
    end

    resources :vouchers, only: [:index, :update]

    resources :products, only: [:index, :show] do
      collection do
        post :index
      end
    end

    resources :favorites, only: [:index, :create, :destroy] do
      member do
        get :is_collect
      end
    end

    resources :fanships, only: [:index, :create, :destroy] do
      member do
        get :is_collect
      end
    end

    resources :contacts, only: [:index, :show, :create, :update, :destroy] do
      member do
        post 'set_default_contact'
      end
      collection do
        get 'default_contact'
        get 'options'
      end
    end

    resources :categories, only: [:index] do
      collection do
        get 'tree'
      end
    end

    resources :brands, only: [:index, :show]  do
      collection do
        get 'show_by_ids'
      end
    end
    resources :users, only: [:show, :update]
  end


  namespace :core do
    resources :accounts, only: [:update, :create] do
      collection do
        post :resend_activation_code
        post :forget_password
      end
    end
    resources :sessions, only: [:destroy]
    resources :connections, only: [:new, :create]
    resources :reports, only: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

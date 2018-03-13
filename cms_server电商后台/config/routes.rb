Rails.application.routes.draw do

  namespace :auction do
    resources :apply_logs
  end
  namespace :auction do
    resources :promotion_activity_apply_products
  end
  namespace :auction do
    resources :promotion_activity_applies do
      member do
        get :good_approved
      end
      collection do
        get :good_audit
        get :good_audit_unpass
      end
    end
  end
  namespace :auction do
    resources :promotion_activities do
      member do
        get :pass
        get :unpass
        get :check
        get :close_activity
      end
    end
    resources :check_logs
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :manage do
    resources :app_versions
  end
  namespace :auction do
    resources :levels
  end

  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end

  draw :supplier
  root 'manage/homes#index'
  resources :sessions
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#logout'

  namespace :auction do
    resources :carousels
    resources :categories
    resources :brands
    resources :attributes
    resources :cashiers do
      member do
        post :collect_money
        get :pay_detailed
      end
      collection do
        get :batch_search
      end
    end
    resources :products, only: [:index, :show, :edit, :update] do
      collection do
        get 'item_form'
        post :review
        get 'ms_review_index'
        get 'zj_review_index'
        get 'cw_review_index'
        get 'editor_review_index'
        get :get_attributes
        get :get_next_categories
        get :image_form
        post :destroy_image
        post :batch_shelf
        post :batch_ms_review
        post :batch_zj_review
        post :batch_cw_review
        get 'review_log'
        get 'batch_edit_form'
        post 'batch_update'
      end
      member do
        post :ms_review
        post :zj_review
        post :cw_review
        post :bj_review
        post :shelf
        post :change_discount
        get :editor_edit
        put :editor_update
      end
    end

    resources :pic_ads do
      member do
        get 'up_move'
        get 'down_move'
        get 'up_status'
        get 'down_status'
      end
    end
    resources :themes do
      member do
        get 'up_move'
        get 'down_move'
        get 'up_status'
        get 'down_status'
      end
    end
    resources :seckills

    resources :trades do
      collection do
        post :audit
        post :freezed
      end
    end

    resources :supplier_trades do
      collection do
        post :freezed
        post :reject_cancel
        post :receive
        post :returning
        post :cancel
        get  :rejects
        get  :returns
        get  :return_show
        get  :return_status_records
        get  :pay_records
        get  :return_pay_records
      end
    end



    resources :units do
      collection do
        post 'audit'
        post :apply_refund
        post 'transfer'
        post 'freezed'
        get  :collapse_table
      end
    end

    resources :trade_refunds do
      collection do
        post :transfer
      end

    end


    resources :voucher_trades, only: [:index] do
      member do
        post :notify_drp_service
      end
    end

    resources :mails
    resources :users

    # resources :images do
    #   collection do
    #     post 'upload'
    #   end
    # end
  end

  resources :images do
    collection do
      post 'upload'
      put 'mult_upload'
    end
  end


  namespace :auction do
    resources :cities
  end
  namespace :pay do
    resources :cmb_signs
  end
  namespace :retail do
    resources :carts
  end
  namespace :manage do
    resources :users
  end
  namespace :manage do
    resources :roles
  end
  namespace :manage do
    resources :authority_role_relationships
  end
  namespace :manage do
    resources :authorities
  end

  namespace :manage do
    resources :editors do
      collection do
        get :reset_password
        post :update_password
      end
    end
  end

  namespace :auction do
    resources :vouchers
  end
  namespace :auction do
    resources :values
  end
  namespace :auction do
    resources :transactions
  end
  namespace :auction do
    resources :trades_updatings
  end

  namespace :auction do
    resources :towns
  end
  namespace :auction do
    resources :sms do
      member do
        get 'send_sms'
      end
    end
  end

  namespace :auction do
    resources :provinces
  end

  namespace :auction do
    resources :multibuys
  end
  namespace :auction do
    resources :favorites
  end
  namespace :auction do
    resources :fanships
  end
  namespace :auction do
    resources :events do
      member do
        get 'published'
      end
    end
  end
  namespace :auction do
    resources :coupons do
      member do
        get 'published'
      end
    end
  end
  namespace :auction do
    resources :countries
  end
  namespace :auction do
    resources :contacts
  end
  namespace :auction do
    resources :categories
  end
  namespace :auction do
    resources :cards
  end
  namespace :auction do
    resources :brands
  end
  namespace :auction do
    resources :attributes
  end
  namespace :core do
    resources :reports
    resources :connections
    resources :accounts
  end

  namespace :manage do
    resources :providers
  end
  namespace :manage do
    resources :report_forms do
      member do
        get 'update_status'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

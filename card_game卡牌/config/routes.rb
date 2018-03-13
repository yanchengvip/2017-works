Rails.application.routes.draw do
  namespace :mammon do
    resources :cards
    resources :invite_records
    resources :user_cards
    resources :user_codes
    resources :user_winnings do
      collection do
        get :period_list
        get :download_csv
      end
    end
    resources :periods do
      collection do
        get 'unlock'
        get 'rule'
        post :save_rule
        get 'card'
        post :give_card
      end
      member do
        get 'code'
        post :give_code
      end
    end
  end

  resources :recoveries do
    member do
      get :shut_down
      get :open
      get :modify_sort_index
    end
  end
  resources :recovery_items do
    collection do
      get :display
    end
  end
  resources :account_ticket_balance_details
  namespace :pay do
    resources :withdrawals_orders do
      collection do
        get :withdraw_cash
        post :complete
        post :cancel
      end
    end
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  namespace :promotion do
    resources :red_package_rules, except: [:destroy] do
      collection do
        get 'get_item_form'
      end
      member do
        post :destroy_item
        post :shelf
      end
    end
    resources :red_package_rule_items
    resources :red_packages
    resources :red_package_items
  end

  namespace :api do
    namespace :mammon do
      resources :cards, only: [] do
        collection do
          post :status
          post :use
        end
      end
      resources :user_codes do
        collection do
          get :my_codes
          get :my_awards
        end
      end
      resources :user_cards
      resources :invite_records do
        collection do
          get :get_rewarded
          get :invitation_registered
          get :invitation_successful
        end
      end
      resources :periods, only: [:index] do
        collection do
          get 'welfare'
          get :open_info
          get :user_win_info
          get :is_open
        end
      end
    end
    post 'sms_message/send_sms'
    get 'chest_record_items/index'
    get "chest_record_items/total"
    get 'chest_records/index'
    get 'box_lucky_walls/index'
    get 'box_lucky_walls/wall_show_user'
    post 'box_lucky_walls/exchange_prize_code'
    resources :chest_broadcasts, only: [:index]
    resources :chest_records, only: [:index] do
      collection do
        get "awards"
        get :alipay
        get :pay_amount
        post :alipay_notify
        post :express
        get :jd_info
      end
    end
    resources :recoveries, only: [:index] do
      collection do
        get :prize_count
        post :exchange_cash
        get :get_yesterday_recovery
        get :recovery_items
      end
    end
    resources :red_packages, only: [:index] do
      collection do
        post :draw
        post :new_red_package
      end
    end
    post 'sign_records/sign_records'
    get 'sign_records/setting_list'

    resources :withdrawals_orders do
      collection do
        post :bind_alipay
        post :apply
        get  :balance_list
        get  :balance_detail
      end
    end

  end

  resources :chest_records, only: [:index] do
    collection do

    end
    member do
      get 'get_ship_info'
      post :ship
      post :grant_voucher
    end
  end

  resources :account_ticket_details, only: [:index] do
    collection do
      get "treasure_amount"
      get :open_ticket_list

    end

  end

  namespace :api do
    resources :chest_boxs, only: [:index] do
      collection do
        get :syn_user
        post :syn_user
        get :h5_box_detail
        get "h5_landing_box"
        get :h5_landing_binding_mobile
        get "index"
        post 'draw'
        get 'notice'
        get 'prizes'
        get "current_notice"
        get :app_landing_box
        get :app_landing_box_detail
        post :app_box_binding_user
        post :draw_cash
        get :draw_cash_index
      end
      member do
        get "left_prize_count"
      end
    end
    # get 'chest_boxs/:id/left_prize_count', to: 'chest_boxs#left_prize_count'
    get 'chest_records/index'
  end

  root 'homes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login' => 'sessions#index'
  get 'logout' => 'sessions#destroy'
  get 'profile' => 'admins#show'

  resources :sessions, only: [:index, :create, :destroy]
  resources :admins do
    member do
      get 'change_pwd'
      post 'update_pwd'
      post 'reset_pwd'
    end
    collection do
      get 'audited_logs'
      get 'audited_type'
    end
  end

  resources :cards do
    collection do
      post 'update'
      get 'get_order_num'
    end
    member do
      get 'get_card'
    end
  end
  resources :images do
    collection do
      post 'upload'
    end
  end
  resources :battle_products do
    collection do
      post 'destroy'
      post 'update'
      post :update_status
      post 'inventory_count_change'
      get 'inventory_count_manage'
      get 'orders'
      get 'order_edit'
      post 'order_update'
    end
    member do
      get 'shelf_form'
      post 'shelf'
    end
  end

  resources :battles do
    collection do
      post 'destroy'
      post 'update'
      get 'search_bp'
      post 'update_status'
      get 'battle_package_tr'
      get 'battle_package_tr_fail'
      get 'battle_package_table'
      get 'csv_index'
    end

  end

  resources :battle_rules do
    collection do
      post 'destroy'
      post 'update'
      post 'update_status'
      get 'set_card_rule'
      get 'get_rule_packages'
      get 'selected_rule_package'
    end
  end


  resources :mall_products do
    collection do
      post 'destroy'
      post 'update'
      get 'onshelf'
      post :update_status
      post :sort
    end
    member do
      post 'shelf'
      post 'resort'
    end
  end

  resources :product_tags do
    collection do
      post 'destroy'
      post 'update'
    end

  end

  resources :mall_orders do
    collection do
      post 'update'
      get 'csv_index'
    end
  end

  resources :packages do
    collection do
      get 'content_form'
      post 'update'
      get 'buy_record'
      get 'get_package_type'
      post 'save_scheme'
    end
    member do
      post 'shelf'
      get 'prize_scheme'
      get 'scheme_form'
      get 'show_scheme'
      post 'destroy_item_scheme'
    end
  end

  resources :package_types

  resources :package_items, only: [:destroy]

  resources :activities do
    collection do
      get 'item_form'
      post 'update'
      post 'destroy_item'
    end
  end

  resources :extreme_chests do
    collection do
      get 'item_form'
      post 'update'
      post 'destroy_item'
    end
  end

  resources :msg_records do
    collection do
      post 'update'
      get 'notices'
      get 'activities'
    end
    member do
      get 'up_published'
      get 'down_published'
    end
  end

  resources :web_settings, only: [:create, :update] do
    collection do
      get 'card_give'
      get 'match_point'
      get 'game_tip'
      get 'glutton_rule'
    end
  end

  resources :app_versions

  resources :roles do
    collection do
      post 'update'
      post 'destroy'
    end
  end
  resources :authority_resources do
    collection do
      post 'update'
      post 'destroy'
    end
  end


  resources :battle_winning_records do
    collection do
      post 'update'
      get 'fail_order_show'
      get 'fail_order_edit'
      get 'csv_index'
    end
  end


  resources :gifts do
    collection do
      get 'item_form'
      post 'update'
      post 'destroy_item'
    end
  end

  resources :copies do
    collection do
      post 'update'
    end
  end


  resources :download_csv do
    collection do
      get 'order_info_csv'
      get 'download_csv_file'
      get 'winning_order_info_csv'
      get 'battle_card_info_csv'
      get 'user_info_csv'
      get 'user_card_info_csv'
      get 'user_calculus_change'
    end
  end
  resources :users do
    collection do
      get 'user_login_first'
    end
  end
  resources :card_user_records
  resources :account_logs

  resources :card_user_owns, only: [:index, :new, :create] do
    collection do
      get 'item_form'
      get 'new_give'
      get 'user_energy'
      post 'create_give'
    end
  end

  resources :task_settings do
    collection do
      get 'item_form'
      post 'update'
      post 'destroy_item'
      get 'dynamic'
    end
  end

  resources :forage_settings, only: [:create, :update] do
    collection do
      get 'set_forage'
    end
  end

  resources :glutton_settings, only: [] do
    collection do
      get 'set_glutton'
      get 'content_form'
      post 'save_gluttons'
      get 'prize_item'
      get 'text_item'
      post 'destroy_prize'
      post 'destroy_text'
    end
  end

  resources :energy_products do
    collection do
      post 'update'
      post 'destroy_item'
      get 'item_form'
      get 'get_order_num'
    end
    member do
      post 'shelf'
    end
  end


  resources :card_rules do
    collection do
      post 'update'
    end
  end

  resources :operate_logs, only: [:index]

  resources :qrcodes do
    collection do
      get 'download'
      get 'apurl'
    end
  end

  resources :headimgs, except: [:show, :edit, :update]

  resources :game_types do
    collection do
      get 'get_this_tag_products'
      get 'get_chosed_products'
      get 'get_chosed_game_rule'
      get 'get_chosed_card_bag'
      post 'change_desc'
      get 'get_game_type_name'
      get 'game_products'
      get 'self_game_products'
      get 'mall_products'
      get 'show_product'
      post 'game_product_shelf'
      post 'self_game_product_shelf'
      get 'round_card_form'
    end
    member do
      post 'shelf'
      post 'change_product_tag'
      post 'update'
    end
  end

  resources :game_rules do
    collection do
      get 'round_time_form'
      get 'round_card_form'
    end
  end
  resources :card_bags
  resources :games, only: [:index, :show]
  resources :self_game_rules do
    member do
      post 'shelf'
    end
    collection do
      get 'round_time_form'
      get 'round_card_form'
    end
  end

  resources :product_types do
    collection do
      post 'destroy'
      post 'update'
    end
  end

  resources :game_product_tags do
    member do
      post 'able'
    end
  end

  resources :mall_product_tags do
    member do
      post 'able'
    end
  end

  resources :statis, only: [:index] do
    collection do
      get 'energy'
      get 'glory'
      get 'score'
      get 'balance'
      get 'channel'
      get 'activy'
      get 'game'
      get 'recharge'
      get 'exchange'
      get 'request_source'
      get 'request_source_day'
      get 'download_source'
      get 'download_source_day'
      get 'down_csv'
      get 'down_day_csv'
      get 'csv'
      get "pv_count"
      get "app_box_count"
      get "mammon"
      get 'invite_count'
      get 'attack_record'
      get 'package_record'
    end
  end

  resources :mail_types
  resources :mails do
    member do
      post 'update'
    end
  end
  resources :game_luckies do
    member do
      post 'update'
    end
  end
  resources :msg_chats
  resources :head_frames do
    member do
      post 'update'
    end
  end
  resources :game_props do
    collection do
      get 'demons'
      get 'vouchers'
      get 'silk_bags'
      get 'get_card_form'
      post :create_demon
      post :create_silk_bag
      post :create_voucher
    end
    member do
      post :update_demon
      post :update_silk_bag
      post :update_voucher
    end
  end
  resources :glutton_skills
  resources :glutton_levels do
    collection do
      get 'week_prop_form'
      get 'up_prop_form'
      post :destroy_prop
    end
    member do
      post 'update'
    end
  end

  resources :treasure_boxs do
    collection do
    end
    member do
      get 'manage_jackpot'
      get 'get_jackpot_form'
      get 'new_jackpot'
      get 'new_master_jackpot'
      get 'new_normal_jackpot'
      get 'edit_jackpot'
      get 'edit_master_jackpot'
      get 'edit_normal_jackpot'
      post :save_master_jackpot
      post :save_normal_jackpot
      post :update_master_jackpot
      post :update_normal_jackpot
      post :destroy_jackpot
      get 'level1_form'
      get 'level2_form'
      get 'level3_form'
      get 'get_product'
      get 'level1_type'
      get 'level2_type'

    end
  end

  resources :box_lucky_walls do
    collection do
      post :update
      post :other_create
      post :main_pro_update
      post :destroy_wall
    end
  end

  resources :box_prize_codes do
    collection do
      post :create_box_prize
      post :add_box_prize_codes
      post :destroy_prize
      post :box_prize_status
      get :down_csv
    end
  end
  resources :chest_prizes do
    member do
      post 'update'
    end
  end
  resources :chest_boxs do
    member do
      post :shelf
      post :copy
      post :add_prize
      get 'new_prize'
    end
    collection do
      get 'get_prize_form'
      get 'get_prize'
      post :destroy_prize
      get 'cash_box'
      post :cash_box
      post :save_cash_box
      get 'get_gain_form'
    end
  end

  resources :settings do
    collection do
      get 'active_user'
      post :save_active_user
    end
  end


  resources :sign_gift_settings do
    collection do
      post :destroy_gift
    end
  end

  resources :chest_box_msgs do
    collection do
      post :msg_create
    end
  end

  resources :account_ticket


  resources :chest_broadcasts do
    member do
      post :shelf
    end
  end

  resources :chest_orders, only: [:index] do
    collection do
      get 'cancels'
      get 'phone'
      get 'phone_static'
    end
    member do
      post :confirm
      get 'test_status'
    end
  end

  resources :jd_cards
  resources :recharges do
    collection do
      get 'phone'
      get 'ticket'
      get 'bxf'
      get 'coupons'
      get 'cancels'
      post :confirm
    end
    member do
      post :cancels_reconfirm
    end
  end
  resources :game_leagues do
    collection do
      get 'get_prize'
      get 'relive_rule'
      post :relive
      get 'league_rule'
      post 'save_league_rule'
    end
    member do
      post :update
      post :shelf
      post :copy
    end
  end


end

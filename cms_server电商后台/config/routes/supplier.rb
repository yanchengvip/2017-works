namespace :supplier do
  post 'session/create'
  get 'session/destroy'
  get 'session/new'


  resources :promotion_activity_suppliers do
    collection do
      get :report_product
      get :batch_search
      post :apply_product
      get :choose_product
      get :no_begin_activity
      get :proceed_activity
      get :end_activity
    end
  end
  resources :promotion_activity_applies do
    member do
      get :refer_check
    end
  end
  resources :promotion_activity_apply_products do
    collection do

      get :apply_product
      get :choice_product
    end
  end
  resources :units,  only: [:index] do
    collection do
      post :receive
    end
  end

  resources :trades do
    member do
      get :print
      post :ship
      post :return
      post :reject
    end
  end

  resources :products do
    member do
      post :review
      # get :get_next_categories
    end
    collection do
      post :destroy_sku
      get :sku_form
      get :get_attributes
      get :get_next_categories
      get :image_form
      get :import_products
      post :create_import_products
      post :destroy_image
      get :custom_value_form
      post :destroy_custom_value
    end
  end

  resources :report_forms
  resources :providers do
    collection do
      get :reset_password
      post :update_password
    end
  end
  resources :skus, only: [:index, :update, :show, :edit, :destroy]
  root 'trades#index'

  resources :images do
    collection do
      post 'upload'
    end
  end


end

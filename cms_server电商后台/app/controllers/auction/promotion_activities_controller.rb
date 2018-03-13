class Auction::PromotionActivitiesController < ApplicationController
  before_action :set_auction_promotion_activity, only: [:show, :edit, :update, :destroy, :pass, :unpass, :check, :close_activity]
  before_action :side_menus4

  # GET /auction/promotion_activities
  # GET /auction/promotion_activities.json
  def index
    @bread_menu = {m1: '活动管理', m2: '活动管理', m2_url: '/auction/promotion_activities', m3: '活动列表', add: '/auction/promotion_activities/new', s: 'activity_search'}
    @auction_promotion_activities = Auction::PromotionActivity.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction/promotion_activities/1
  # GET /auction/promotion_activities/1.json
  def show
  end
  def check
  end

  # GET /auction/promotion_activities/new
  def new
    @bread_menu = {m1: '活动管理', m2: '活动管理', m2_url: '/auction/promotion_activities', m3: '新增活动'}
    @auction_promotion_activity = Auction::PromotionActivity.new
    @auction_promotion_activity_discount_type = Auction::PromotionActivity::DISCOUNTTYPE.invert.to_a
    @auction_promotion_activity_supplier = Auction::PromotionActivity::APPOINTSUPPLIER.invert.to_a
    @auction_promotion_activity_category = Auction::PromotionActivity::APPOINTCATEGORY.invert.to_a
  end

  # GET /auction/promotion_activities/1/edit
  def edit
    @bread_menu = {m1: '活动管理', m2: '活动管理', m2_url: '/auction/promotion_activities', m3: '修改活动'}
    @auction_promotion_activity_discount_type = Auction::PromotionActivity::DISCOUNTTYPE.invert.to_a
    @auction_promotion_activity_supplier = Auction::PromotionActivity::APPOINTSUPPLIER.invert.to_a
    @auction_promotion_activity_category = Auction::PromotionActivity::APPOINTCATEGORY.invert.to_a
  end

  # POST /auction/promotion_activities
  # POST /auction/promotion_activities.json
  def create

    @auction_promotion_activity = Auction::PromotionActivity.new(auction_promotion_activity_params.merge(:user_id => current_user.id, :status => 1))
    if @auction_promotion_activity.save
      ActiveRecord::Base.transaction do

        if auction_promotion_activity_params[:appoint_supplier] == "1"

          Manage::Provider.active.each do |supplier|
            Auction::PromotionActivitySupplier.create(:promotion_activity_id => @auction_promotion_activity.id, :supplier_id => supplier.id)
          end
        else

          if auction_promotion_activity_params[:supplier_id].length > 1
            auction_promotion_activity_params[:supplier_id].each do |supplier_id|
              if supplier_id != ""
                Auction::PromotionActivitySupplier.create(:promotion_activity_id => @auction_promotion_activity.id, :supplier_id => supplier_id)
              end
            end
          else
            Auction::PromotionActivitySupplier.create(:promotion_activity_id => @auction_promotion_activity.id, :supplier_id => auction_promotion_activity_params[:supplier_id])
          end

        end


        if auction_promotion_activity_params[:appoint_category] == "1"
          Auction::Category.active.each do |category|
            Auction::PromotionActivityCategory.create(:promotion_activity_id => @auction_promotion_activity.id, :category_id => category.id)
          end
        else

          if auction_promotion_activity_params[:category_id].length > 1
            auction_promotion_activity_params[:category_id].each do |category_id|
              if category_id != ""
                Auction::PromotionActivityCategory.create(:promotion_activity_id => @auction_promotion_activity.id, :category_id => category_id)
              end
            end
          else
            Auction::PromotionActivityCategory.create(:promotion_activity_id => @auction_promotion_activity.id, :category_id => auction_promotion_activity_params[:category_id])
          end

        end

      end

      flash[:success] = '添加成功'
    else
      flash[:danger] = '添加失败'
    end
    redirect_to '/auction/promotion_activities'
  end

  # PATCH/PUT /auction/promotion_activities/1
  # PATCH/PUT /auction/promotion_activities/1.json
  def update
    if @auction_promotion_activity.update(auction_promotion_activity_params.merge(:status => 1))
      ActiveRecord::Base.transaction do

        if auction_promotion_activity_params[:appoint_supplier] == "1"
          @auction_promotion_activity.supplier.map{|item| item.destroy}
          Manage::Provider.active.each do |supplier|
            Auction::PromotionActivitySupplier.create(:promotion_activity_id => @auction_promotion_activity.id, :supplier_id => supplier.id)
          end
        else
          @auction_promotion_activity.supplier.map{|item| item.destroy}
          if auction_promotion_activity_params[:supplier_id].length > 1
            auction_promotion_activity_params[:supplier_id].each do |supplier_id|
              if supplier_id != ""
                Auction::PromotionActivitySupplier.create(:promotion_activity_id => @auction_promotion_activity.id, :supplier_id => supplier_id)
              end
            end
          else
            Auction::PromotionActivitySupplier.create(:promotion_activity_id => @auction_promotion_activity.id, :supplier_id => auction_promotion_activity_params[:supplier_id])
          end

        end


        if auction_promotion_activity_params[:appoint_category] == "1"
          @auction_promotion_activity.category.map{|item| item.destroy}
          Auction::Category.active.each do |category|
            Auction::PromotionActivityCategory.create(:promotion_activity_id => @auction_promotion_activity.id, :category_id => category.id)
          end
        else
          @auction_promotion_activity.category.map{|item| item.destroy}
          if auction_promotion_activity_params[:category_id].length > 1
            auction_promotion_activity_params[:category_id].each do |category_id|
              if category_id != ""
                Auction::PromotionActivityCategory.create(:promotion_activity_id => @auction_promotion_activity.id, :category_id => category_id)
              end
            end
          else
            Auction::PromotionActivityCategory.create(:promotion_activity_id => @auction_promotion_activity.id, :category_id => auction_promotion_activity_params[:category_id])
          end

        end

      end
      flash[:success] = '编辑成功'
    else
      flash[:danger] = '编辑失败'
    end
    redirect_to '/auction/promotion_activities'
  end

  # DELETE /auction/promotion_activities/1
  # DELETE /auction/promotion_activities/1.json
  def destroy
    @auction_promotion_activity.destroy
    respond_to do |format|
      format.html { redirect_to auction_promotion_activities_url, notice: 'Promotion activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  #通过
  def pass
    status = params[:status]
    if status == "1" #运营审批 通过变成总监审批
      @auction_promotion_activity.update(:status => 5) #状态变成了待总监审核
    elsif status == "5"
      @auction_promotion_activity.update(:status => 6) #状态变成了待财务审核
    elsif status == "6"
      @auction_promotion_activity.update(:status => 3) #状态变成了通过
      if !@auction_promotion_activity.apply.blank? && !@auction_promotion_activity.apply.apply_products.blank?
        ids = @auction_promotion_activity.apply.apply_products.map{|item| item.product_id}
        provider_prices = @auction_promotion_activity.apply.apply_products.map{|item| item.provider_price}
        ids.each_with_index do |id, index|
          product = Auction::Product.find(id)
          product.update(:promotion_provider_price => provider_prices[index], :promotion_activity_id => @auction_promotion_activity.id, :promotion_activity_begin => @auction_promotion_activity.promotion_begin, :promotion_activity_end => @auction_promotion_activity.promotion_end)
        end
      end
    end
    if Auction::CheckLog.create(:pass_user_id => current_user.id, :content => params[:content], :activity_id => @auction_promotion_activity.id)
      flash[:success] = '成功'
    else
      flash[:danger] = '失败'
    end
    redirect_to '/auction/promotion_activities'
  end
  #驳回
  def unpass
    status = params[:status]
    if status == "1" #运营审批
      @auction_promotion_activity.update(:status => 2) #状态变成了驳回
    elsif status == "5"
      @auction_promotion_activity.update(:status => 2) #状态变成了待运营审核
    elsif status == "6"
      @auction_promotion_activity.update(:status => 2) #状态变成了驳回
    end
    if Auction::CheckLog.create(:unpass_user_id => current_user.id, :content => params[:content], :activity_id => @auction_promotion_activity.id)
      flash[:success] = '成功'
    else
      flash[:danger] = '失败'
    end
    redirect_to '/auction/promotion_activities'
  end
  #结束活动
  def close_activity
    products = Auction::Product.where(promotion_activity_id: @auction_promotion_activity.id)
    apply = @auction_promotion_activity.apply
    if @auction_promotion_activity.update(:status => 4)

      if !apply.blank?
        apply.update(:status => 4)
      end

      if !products.blank?
        products.each do |product|
          product.update(:promotion_activity_id => nil, :promotion_activity_begin => nil, :promotion_activity_end => nil, :promotion_provider_price => nil)
        end
      end
      flash[:success] = '成功'
    else
      flash[:danger] = '失败'
    end
    redirect_to '/auction/promotion_activities'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_promotion_activity
      @auction_promotion_activity = Auction::PromotionActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_promotion_activity_params
      params.require(:auction_promotion_activity).permit!
    end
end

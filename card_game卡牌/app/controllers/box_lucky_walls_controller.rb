class BoxLuckyWallsController < ApplicationController
  before_action :side_menus10
  skip_before_action :verify_authenticity_token

  def index
    @main_product = BoxLuckyWall.where(promotion_type: 1, status: 1).active.first
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @main_product&.image.to_s
    @thumbnail_path = @main_product&.image.to_s
    @other_products = BoxLuckyWall.where(promotion_type: 2, status: 1).active.page(params[:page]).per(30)
  end



  def new

  end


  def edit
    @box_lucky_wall = BoxLuckyWall.find(params[:id])
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @box_lucky_wall&.image.to_s
    @thumbnail_path = @box_lucky_wall&.image.to_s
  end

  def update
    @box_lucky_wall = BoxLuckyWall.find(params[:id])
    @box_lucky_wall.update_attributes(box_lucky_walls_params.merge({image: params[:thumbnail]}))
    redirect_to '/box_lucky_walls'
  end

  def other_create
    BoxLuckyWall.create(box_lucky_walls_params.merge({image: params[:thumbnail], promotion_type: 2}))
    flash[:success] = '成功'
    redirect_to '/box_lucky_walls'
  end

  def main_pro_update
    @main_product = BoxLuckyWall.where(promotion_type: 1, status: 1).active.first
    if @main_product
      @main_product.update_attributes(box_lucky_walls_params.merge({image: params[:thumbnail]}))
    else
      BoxLuckyWall.create(box_lucky_walls_params.merge({image: params[:thumbnail], promotion_type: 1}))
    end
    flash[:success] = '成功'
    redirect_to '/box_lucky_walls'
  end


  def destroy_wall
    BoxLuckyWall.where(id: params[:id]).first.destroy
    flash[:success] = '刪除成功'
    redirect_to '/box_lucky_walls'
  end





  private

  def box_lucky_walls_params
    params.permit(:title, :name, :content, :price, :promotion_words, :image, :lucky_user_num, :promotion_type,:is_over,:sort_num)
  end
end

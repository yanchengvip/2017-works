class Auction::CategoriesController < ApplicationController
  before_action :set_auction_category, only: [:show, :edit, :update, :destroy]

  # GET /auction/categories
  # GET /auction/categories.json
  def index
    categories = {
      "categoryId": params[:ids]
    }
    auction_categories = Auction::Category.list categories
    if auction_categories[:comm][:code] == "200"
      render json: {status: auction_categories[:comm][:code].to_i, msg: auction_categories[:comm][:msg], data: {auction_categories: auction_categories[:data]}}
    else
      render json: {status: auction_categories[:comm][:code].to_i, msg: auction_categories[:comm][:msg], data: {}}
    end
  end
  #树形列表
  # GET /auction/categories/tree
  def tree
    render json: {status: 200, msg: "成功", data: {"category": {
        "id": 1,
        "name": "wsa",
        "children": {
            "id": 1,
            "name": "sxaz",
            "children": {
                "id": 1,
                "name": "eddc"
            }
        }
    }}} and return
    @category = Auction::Category.find(params[:id])
    def @category.children; self.class.active.published.scoped(:conditions => { :parent_id => self.id }).map { |child| def child.children; self.class.active.published.scoped(:conditions => { :parent_id => self.id }); end; child }; end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_category
      @auction_category = Auction::Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_category_params
      params.fetch(:auction_category, {})
    end
end

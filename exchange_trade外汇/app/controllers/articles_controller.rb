class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]


  # 获取新闻列表。
  #
  # GET /articles.json
  #
  # @param [integer] q[exchange_product_id_eq]  外汇品种id
  # @param [string] q[title_cont]  标题
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{articles: Array<Article>}, status: 200})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def index
    @articles = Article.active.ransack(params[:q]).result.order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取新闻列表成功", data: {articles: @articles.as_json(Article.xml_options) }}
  end

  # 获取新闻详情。
  #
  # GET /articles/1.json
  #
  # @return ({data: {article: <Article>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def show
    render json: {status: 200, msg: "获取新闻详情成功", data: {article: @article.as_json(Article.xml_options) }}
  end


  # 点赞新闻
  #
  # GET /articles/id/like
  #
  # @param id [integer] 新闻id
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def like
    article = Article.acquire(params[:id])
    @currnet_user.create_action(:like, target: article)
    render json: {status: 200, msg: "点赞成功", data: {}}
  end


  # 取消点赞新闻
  #
  # GET /articles/id/unlike
  #
  # @param id [integer] 新闻id
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def unlike
    article = Article.acquire(params[:id])
    @currnet_user.destroy_action(:like, target: article)
    render json: {status: 200, msg: "取消点赞成功", data: {}}
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :published_at, :content, :active, :published, :from_url, :img)
    end
end

class SearchsController < ApplicationController

  # 搜索列表。
  #
  # GET /searchs
  #
  # @param search [string] 搜索参数
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{datas: Array<Article>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    articles = Article.active.where(:title => params[:search]).order(created_at: :desc).paginate(:page => params[:page] || 1)
    accounts = Account.active.where(:name => params[:search]).order(created_at: :desc).paginate(:page => params[:page] || 1)
    trades = Trade.active.where(:account_id => Account.where(:name => params[:search]).map{|item| item.id}).order(created_at: :desc).paginate(:page => params[:page] || 1)
    if session[:dealer_id] == 1 #模拟盘账户
      render json: {status: 200, msg: "搜索成功", data: {articles: articles.as_json(Article.xml_options), accounts: accounts.as_json, trades: trades.as_json}}
    else
      render json: {status: 200, msg: "搜索成功", data: {articles: articles.as_json(Article.xml_options), accounts: accounts.as_json}}
    end

  end

end

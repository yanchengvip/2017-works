class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # 获取评论列表。
  #
  # GET /comments
  #
  # @param [integer] q[:table_id_eq]  关联表id
  # @param [string] q[:table_name_eq]  关联表 表名
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{comments: Array<Comment, User>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    @comments = Comment.active.includes(:user).ransack(params[:q]).result.order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取评论列表成功", data: {comment: @comments.as_json(Comment.xml_options) }}
  end


  #用户发评论接口
  # POST /comments
  # @param [Hash] comment 评论
  # @param [string] comment[content]  评论内容
  # @param [integer] comment[table_id] 关联表id(article.id)
  # @param [string]  comment[table_type] 关联表 表名(Article)
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    if comment_params[:content] && comment_params[:content].length < 1000 && comment_params[:table_id] && comment_params[:table_type]
      comment = Comment.new(comment_params.merge( request_ip: request.remote_ip, user_id: @current_user.id ))
      if comment.save
        render json: {status: 200, msg: "评论成功", data: {comment: comment}}
      else
        render json: {status: 500, msg: "评论失败", data: {}}
      end
    else
      render json: {status: 500, msg: "评论失败,评论内容为空,评论内容超过1000字", data: {}}
    end
  end


  #删除评论接口
  # DELETE /comments/1
  # DELETE /comments/1.json
  # return ({data: {}, status: 200/500, message: "success" / "权限不够"})
  def destroy
    if @comment.user_id == @current_user.id
      @comment.destroy
      format.json { render json: {status: 200, msg: '删除成功', data: {}} }
    else
      format.json { render json: {status: 500, msg: '删除失败,不是自己的评论', data: {}} }
    end
  end


  # 点赞评论
  #
  # GET /articles/id/like
  #
  # @param id [integer] 评论id
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def like
    comment = Comment.acquire(params[:id])
    @currnet_user.create_action(:like, target: comment)
    render json: {status: 200, msg: "点赞成功", data: {}}
  end


  # 取消点赞评论
  #
  # GET /articles/id/unlike
  #
  # @param id [integer] 评论id
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def unlike
    comment = Comment.acquire(params[:id])
    @currnet_user.destroy_action(:like, target: comment)
    render json: {status: 200, msg: "取消点赞成功", data: {}}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit!
    end
end

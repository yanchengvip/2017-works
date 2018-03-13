module CancancanAuthorizeResource
  extend ActiveSupport::Concern
  included do
    #authorize_resource :class => false,:only => [:new,:create,:edit,:update,:destroy]
    #skip_authorize_resource [:image,:home]
    rescue_from CanCan::AccessDenied do |exception|
      flash[:danger] = '你没有权限进行此操作！'
      redirect_to '/'
      # respond_to do |format|
      #
      #   #flash[:danger] = exception.message
      #   flash[:danger] = '你没有权限操作此页面！'
      #   format.json { {status: 200, msg: 'succ'} }
      #   format.html { redirect_to '/' }
      # end
    end
  end

end




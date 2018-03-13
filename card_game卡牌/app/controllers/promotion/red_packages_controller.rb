class Promotion::RedPackagesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :side_menus11

  def index
    @promotion_red_packages = Promotion::RedPackage.active.page(params[:page]).per(15)
  end

end

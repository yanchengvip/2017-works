class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, :current_user, :login_filter, :header_menus
  layout 'not_login/application'

  def new
  end

  def create
    if editor = Manage::Editor.login(params[:name], params[:password])
      session[:editor_id] = editor.id
      redirect_to root_url
    else
      redirect_to login_path
    end
  end

  def logout
    session[:editor_id] = nil
    redirect_to login_path
  end

end

class Supplier::SessionController < Supplier::ApplicationController
  skip_before_action :current_user

  def new
    render layout: nil
  end

  def create
    if provider = Supplier::Provider.auth(params[:login], params[:password])
      session[:provider_id] = provider.id
      redirect_to '/supplier'
    else
      redirect_to '/supplier/session/new'
    end
  end

  def destroy
    session[:provider_id] = nil
    redirect_to "/supplier/session/new"
  end
end

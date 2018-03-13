class Auction::MailsController < ApplicationController
  before_action :set_auction_mail, only: [:show, :edit, :update, :destroy]
  before_action :side_menus1

  def index
    @bread_menu = {m1: 'H5管理', m2: 'H5管理', m2_url: '/auction/mails', m3: 'H5列表', add: '/auction/mails/new', s: 'mails_search'}
    @q = Auction::Mail.ransack(params[:q])
    @auction_mails = @q.result.active.page(params[:page]).per(15)
  end

  def show
    @bread_menu = {m1: 'H5管理', m2: 'H5管理', m2_url: '/auction/mails', m3: 'H5详情'}
  end

  def new
    @bread_menu = {m1: 'H5管理', m2: 'H5管理', m2_url: '/auction/mails', m3: '新增H5'}
    @auction_mail = Auction::Mail.new
  end

  def edit
    @bread_menu = {m1: 'H5管理', m2: 'H5管理', m2_url: '/auction/mails', m3: '修改H5'}
  end

  def create
    auction_mail = Auction::Mail.new(auction_mail_params)

    begin
      if auction_mail.save!
        flash_msg('success', '添加H5成功！', 'index')
      end
    rescue Exception => e
      flash_render('danger', "添加H5失败！#{error_msg(auction_mail)}", 'new')
    end
  end

  def update
    begin
      if @auction_mail.update_attributes!(auction_mail_params)
        flash_msg('success', '修改H5成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = '修改H5失败！#{error_msg(@auction_mail)}'
      return redict_to action: 'edit', id: @auction_mail.id
    end
  end

  def destroy
    @auction_mail.destroy
    respond_to do |format|
      format.html { redirect_to auction_mails_url, notice: '已成功删除.' }
      format.json { head :no_content }
    end
  end


  private
  def set_auction_mail
    @auction_mail = Auction::Mail.find(params[:id]) if params[:id]
  end

  def auction_mail_params
    # params.fetch(:auction_mail, {})
    params.require(:auction_mail).permit(:title, :content)
  end

end

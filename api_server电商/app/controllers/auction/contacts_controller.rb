class Auction::ContactsController < ApplicationController

  #  收货地址列表
  #
  # GET /auction/contacts
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  #
  # @return ({data:{auction_contacts: Array<Auction::Contact>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    contacts = {
      "userId": current_user[:id],
      "pageNo": params[:page].to_i,
      "pageSize": params[:per_page].to_i
    }
    auction_contacts = Auction::Contact.listCarts contacts
    if auction_contacts[:comm][:code] == "200"
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {auction_contacts: auction_contacts[:data].map{|x| x.merge({is_default: x['default']})}}}
    else

      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {}}
    end

  end



  #  用户默认地址
  #
  # GET /auction/contacts/default_contact
  #
  # @return ({data:{auction_contacts: Array<Auction::Contact>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def default_contact
    contacts = {
      userId: current_user[:id]
    }
    auction_contacts = Auction::Contact.defaultContact contacts
    if auction_contacts[:data]
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {auction_contacts: auction_contacts[:data].merge({is_default: auction_contacts[:data][:default]})}}
    else
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {}}
    end
  end

  # 收货地址详细信息
  #  GET /auction/contacts/1
  #
  # @param id [integer] 地址id
  #
  # @return ({data:{auction_contact: Array<Auction::Contact>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def show
    contacts = {
      id: params[:id]
    }
    auction_contacts = Auction::Contact.getContacts contacts
    if auction_contacts[:data]
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {auction_contacts: auction_contacts[:data].merge(is_default: auction_contacts[:data][:default])}}
    else
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {auction_contacts: auction_contacts[:data]}}
    end

  end


  # 添加收货地址
  # POST /auction/contacts
  # @param [Hash] auction_contact 收货地址
  # @param [string] contact[name]  名字
  # @param [string]  contact[province] 省份
  # @param [string]  contact[city] 城市
  # @param [string]  contact[town] 县区
  # @param [string]  contact[address] 地址
  # @param [string]  contact[postcode] 邮编
  # @param [string]  contact[phone] 电话
  # @param [string]  contact[id_number] 身份证号码(选填)
  # @param [string]  :is_default 设为默认地址(选填)
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    params[:contact].merge!(user_id: current_user[:id])
    auction_contacts = Auction::Contact.insertContacts params[:contact]
    if auction_contacts[:comm][:code] == "200"
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {auction_contacts:  auction_contacts[:data].merge(is_default: auction_contacts[:data][:default])}}
    else
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {}}
    end
  end

  # 设置默认地址
  # Post /auction/contacts/:id/set_default_contact
  # @param [Hash] auction_contact 收货地址
  # @param [integer] contact[id]  id
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def set_default_contact
    contact = {
      userId: current_user[:id],
      areaId: params[:id]
    }
    auction_contacts = Auction::Contact.setDefaultContact contact
    render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {}}
  end


  # 修改收货地址
  # PATCH/PUT /auction/contacts/1
  # @param [Hash] auction_contact 收货地址
  # @param [string] contact[name]  名字
  # @param [string] contact[id_number] 身份证号码(选填写)
  # @param [string]  contact[province] 省份
  # @param [string]  contact[city] 城市
  # @param [string]  contact[town] 县区
  # @param [string]  contact[address] 地址
  # @param [string]  contact[postcode] 邮编
  # @param [string]  contact[phone] 电话
  # @param [string]  :is_default 设为默认地址(选填)
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def update
    params[:contact].merge!(id: params[:id],userId: current_user[:id])
    auction_contacts = Auction::Contact.updateContacts params[:contact]
    if auction_contacts[:comm][:code] == "200"
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {auction_contacts:  auction_contacts[:data].merge(is_default: auction_contacts[:data][:default])}}
    else
      render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {}}
    end

  end


  #省市区
  def options
    auction_contacts = Auction::Contact.get_contry params
    auction_contacts_countries = Rails.cache.fetch("auction_contacts_countries", expires_in: 60){
      auction_contacts[:data]
    }
    render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: { auction_contacts: auction_contacts_countries} }
  end


  #删除收货地址接口
  # DELETE /auction/contacts/1
  # @param id [integer] 收货地址id
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def destroy
    contacts = {
      addressId: params[:id]
    }
    auction_contacts = Auction::Contact.deleteContacts contacts
    render json: {status: auction_contacts[:comm][:code].to_i, msg: auction_contacts[:comm][:msg], data: {}}
  end

end

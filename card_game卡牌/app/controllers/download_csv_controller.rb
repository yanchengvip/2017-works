class DownloadCsvController < ApplicationController
  authorize_resource :class => false,:only => [:index]
  before_action :side_menus
  skip_before_action :verify_authenticity_token, only: [:index]
  before_action :generate_file_name, only: [:order_info_csv, :winning_order_info_csv, :battle_card_info_csv, :user_info_csv, :user_card_info_csv, :user_calculus_change]
  def index
    @menu_active = '下载记录'
    if params[:statistic_type].to_i == 0
      st = [1, 2, 3, 4, 5, 6]
    else
      st = params[:statistic_type]
    end
    @csv_files = CsvFile.ransack(statistic_type_in: st)
                     .result.order('download_date desc').page(params[:page]).per(15)
  end

  def download_csv_file
    csv_file = CsvFile.find(params[:id])
    count = csv_file.count.to_i + 1
    csv_file.update_attributes(count: count)
    file_path = 'public' + params[:file_path]
    filename = params[:filename]
    respond_to do |format|
      format.csv { send_file file_path, filename: filename }
    end
  end

  #兑换订单统计下载
  def order_info_csv
    header = ['兑换时间','商品sku', '商品库存地', '商品名称', '市场价格','兑换方式', '兑换微积劵','兑换微积分', '收货姓名',
      '收货电话', '收货地址', '是否已支付邮费','运费金额', '订单状态']
    begin
      data_arr = MallOrder.order_info_csv_data params
      MallOrder.custom_save_csv @file_path_temp, data_arr, header
      CsvFile.create(url: @file_path, csv_name: @filename,user_id: current_user.id,
                                    statistic_type: 1, download_date: DateTime.now)
    rescue Exception => e
      ErrorLog.create(title: 'mall_orders统计下载', desc: e.to_s)
    end
    render json: {status: 'ok'}
  end
  #中奖订单统计下载
  def winning_order_info_csv
    header = ['揭晓时间', '商品名称', '市场价格','夺宝期号', '幸运号码','认领时间',
      '用户账号','收货姓名',
      '收货电话', '收货地址','认领状态', '订单状态']
    begin
      data_arr = BattleWinningRecord.winning_order_info_csv_data params
      BattleWinningRecord.custom_save_csv @file_path_temp, data_arr, header
      CsvFile.create(url: @file_path, csv_name: @filename,user_id: current_user.id,statistic_type: 2, download_date: DateTime.now)
    rescue Exception => e
      ErrorLog.create(title: '中奖订单统计下载', desc: e.to_s)
    end
    render json: {status: 'ok'}
  end
  #战役卡牌明细统计下载
  def battle_card_info_csv
    header =
    ['战役上架时间', '战役第一轮开局时间', '战役id','战役名称', '战役规则id','战役轮次',
    '商品sku','商品名称','开启人数', '最大报名人数','使用卡牌玩家总数','累计报名人数','[轮数]','[消耗卡牌总数]','卡牌名','轮数','消耗张数']
    begin
      data_arr = Battle.card_info_csv_data params
      Battle.custom_save_csv @file_path_temp, data_arr, header
      CsvFile.create(url: @file_path, csv_name: @filename,user_id: current_user.id,statistic_type: 3, download_date: DateTime.now)
    rescue Exception => e
      ErrorLog.create(title: '战役卡牌明细统计下载', desc: e.to_s)
    end
    render json: {status: 'ok'}
  end
  #用户注册信息统计下载
  def user_info_csv
    header =
    ['注册时间', '运营推广渠道', '客户端','用户id', '用户昵称','姓名',
    '性别','登录手机','邮箱', '身份证号码','收货地址','登录ip','登录时间',
    '参加战役总场数','消耗能量总数','胜利战役总数']
    begin
      data_arr = User.user_info_csv_data params
      User.custom_save_csv @file_path_temp, data_arr, header
      CsvFile.create(url: @file_path, csv_name: @filename,user_id: current_user.id,statistic_type: 4, download_date: DateTime.now)
    rescue Exception => e
      ErrorLog.create(title: '用户注册信息统计下载', desc: e.to_s)
    end
    render json: {status: 'ok'}
  end
  #用户卡牌使用记录
  def user_card_info_csv
    header =
    ['用户id', '用户昵称', '被别人使用技能的用户id','卡牌id', '战役id','战役名称',
    '使用数量','使用轮次','当前价格', '计费方式','获取方式','创建时间']
    begin
      data_arr = User.user_card_use_info_csv params
      User.custom_save_csv @file_path_temp, data_arr, header
      CsvFile.create(url: @file_path, csv_name: @filename,user_id: current_user.id,statistic_type: 5, download_date: DateTime.now)
    rescue Exception => e
      ErrorLog.create(title: '用户卡牌使用记录统计下载', desc: e.to_s)
    end
    render json: {status: 'ok'}
  end
  #用户充值微积分
  def user_calculus_change
    header =
    ['用户id', '渠道', '变更类型','变更数量', '交易流水号','备注','ip','充值时间']
    begin
      data_arr = AccountLog.account_change params
      AccountLog.custom_save_csv @file_path_temp, data_arr, header
      CsvFile.create(url: @file_path, csv_name: @filename,user_id: current_user.id,statistic_type: 6, download_date: DateTime.now)
    rescue Exception => e
      ErrorLog.create(title: '用户充值微积分统计下载', desc: e.to_s)
    end
    render json: {status: 'ok'}
  end

  private

  def generate_file_name
    if !Dir.exists?('public/uploads/csv/')
      Dir.mkdir('public/uploads/csv/')
    end
    time = Time.now.strftime('%Y%m%d%H%M%S').to_s + Time.now.nsec.to_s[0..3] + rand(10).to_s
    @file_path_temp = 'public/uploads/csv/' + time + '.csv'
    @file_path = '/uploads/csv/' + time + '.csv'
    @filename = time + '.csv'
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu6]
  end

end

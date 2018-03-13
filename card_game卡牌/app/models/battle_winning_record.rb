class BattleWinningRecord < ApplicationRecord
  self.table_name = 'battle_winning_record'
  belongs_to :battle
  belongs_to :user
  belongs_to :address
  has_many :battle_products_copies,through: :battle
  has_many :battle_packages,through: :battle
  #领取类型draw_status
  DRAWSTATUS = {0=>'无',1 =>'商品', 2 => '功勋',3=> '卡牌'}
  #认领状态claim_status
  CLAIMSTATUS = {1 =>'待用户认领', 2 => '用户已认领'}
  #发货状态shipping_status
  SHIPPINGSTATUS = {0 =>'待发货', 1 => '已发货', 2 => '已换功勋', 3 => '已作废',4=>'已领取', 5=>'手机充值卡已领取'}
  include DownloadCsv
  include CsvDataHelper

  #中奖订单列表展示
  def self.show_index params,record_instance
    conditions = []
    values = []
    joins = []
    if params[:battle_code].present?
      conditions << 'battle_code like ?'
      values << "%#{params[:battle_code]}%"
    end

    if params[:good_name].present?
      conditions << 'good_name like ?'
      values << "%#{params[:good_name]}%"
    end

    if params[:create_time_begin].present?
      conditions << 'create_time >= ?'
      values << params[:create_time_begin]
    end

    if params[:create_time_end].present?
      conditions << 'create_time <= ?'
      values << params[:create_time_end]
    end

    if params[:shipping_status].present? && params[:shipping_status].to_i != -1
      conditions << 'shipping_status = ?'
      values << params[:shipping_status]
    end

    if params[:claim_status].present? && params[:claim_status].to_i != -1
      conditions << 'claim_status = ?'
      values << params[:claim_status]
    end
    if params[:mobile].present?
      joins << 'left join user as user on user.id = battle_winning_record.user_id'
      conditions << 'user.mobile like ?'
      values << "%#{params[:mobile]}%"
    end
    @battle_orders = record_instance.constantize.where(conditions.join(' and '),*values)
                         .joins(joins.join('  '))
                         .includes(:battle, :user).page(params[:page].to_i).per(20).order('create_time desc')

  end
end

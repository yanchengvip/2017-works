class Battle < ApplicationRecord
  audited #日志记录
  STATUS = {0 => '下架', 2 => '待开局', 3 => '开局中', 4 => '已开奖', 5 => '修整中', 6 => '开奖中'} #战役状态
  BATTLERANK = {1 => '初级场', 2 => '中级场'}
  has_many :images, -> { where(delete_flag: false) }, as: :table
  has_many :battle_products_copies, -> { where(delete_flag: false) }, :dependent => :destroy
  has_many :battle_rules_copies, -> { where(delete_flag: false) }, :dependent => :destroy
  has_many :battle_packages,-> { where(delete_flag: false) }, :dependent => :destroy
  has_one  :battle_winning_record
  after_create :generate_battle_code
  validates :published_at, presence: true
  include CardDataHelper
  include DownloadCsv



  #复制战役商品
  def create_bp_copy bp_id
    bp = BattleProduct.includes(:images).select(:id, :status, :name, :market_price, :cost_price,
                                                :inventory_count, :postage, :thumbnail, :desc,
                                                :detail_url, :product_tag_id,:sku,:inventory_place)
             .where('id = ? and status = ? and delete_flag = ? and inventory_count >= ?', bp_id, 1, 0, 1).first
    if bp.present?
      bp_params = bp.as_json
      bp_params.delete('id')
      bp_params = bp_params.merge(battle_product_id: bp.id)
      bp_copy = self.battle_products_copies.create!(bp_params)
      bp.images.each do |img|
        bp_copy.images.create!(url: img.url)
      end
    end
  end

  #复制战役规则
  def create_br_copy br_id
    br = BattleRule.select(:id, :name, :bout_number, :open_person_number, :bout_time, :desc,
                           :max_person_number,:card_rule_flag,:max_consume_energy,:taoti_blood).active.where(id: br_id).first
    if br.present?
      br_params = br.as_json
      br_params.delete('id')
      br_params = br_params.merge(battle_rule_id: br.id)
      self.battle_rules_copies.create!(br_params)
    end
  end


  #战役列表显示
  def self.show_index params
    conditions = []
    values = []
    joins = []
    if params[:battle_code].present?
      conditions << 'battle_code like ?'
      values << "%#{params[:battle_code]}%"
    end

    if params[:name].present?
      conditions << 'name like ?'
      values << "%#{params[:name]}%"
    end

    if params[:published_at_begin].present?
      conditions << 'published_at >= ?'
      values << params[:published_at_begin]
    end

    if params[:published_at_end].present?
      conditions << 'published_at <= ?'
      values << params[:published_at_end]
    end

    if params[:status].present? && params[:status].to_i != -1
      conditions << 'status = ?'
      values << params[:status]
    end

    if params[:battle_product_id].present?
      joins << 'left join battle_products_copies as bpc on bpc.battle_id = battles.id'
      conditions << 'bpc.battle_product_id = ?'
      values << params[:battle_product_id]
    end
    if params[:battle_rule_id].present?
      joins << 'left join battle_rules_copies as brc on brc.battle_id = battles.id'
      conditions << 'brc.battle_rule_id = ?'
      values << params[:battle_rule_id]
    end

    @battles = Battle.includes(:battle_rules_copies).joins(joins.join('  ')).where(conditions.join(' and '), *values).active
                   .order('published_at desc')
                   .page(params[:page]).per(20)
  end


  #创建战役礼包
  def create_battle_package params
    if params.present?
      params.each do |pa|
        self.battle_packages.create!(pa.as_json)
      end
    end
  end


  #修改战役礼包
  def update_battle_package params
    old_ids = self.battle_packages.active.pluck(:id)
    new_ids = []
    if params.present?
      params.each do |pa|

        if pa['id'].present?
          bp = BattlePackage.where(id: pa['id']).first
          if bp.present?
            new_ids.push(pa['id'].to_i)
            pa.delete('id')
            bp.update_attributes(pa.as_json)
          end
        else
          self.battle_packages.create!(pa.as_json)
        end
      end

      del_ids = old_ids - new_ids
      del_ids.each do |del_id|
        BattlePackage.find(del_id).destroy
      end
    else
      old_ids.each do |del_id|
        BattlePackage.find(del_id).destroy
      end

    end
  end

  def self.handle_battle_params params
    if params[:published_at_radio].to_i == 1
      #立即上架
      published_at = (Time.now+1.minutes).strftime("%Y-%m-%d %H:%M:%S")
    elsif params[:published_at_radio].to_i == 2
      published_at = params[:published_at_val]
    end

    #领奖设置
    if params[:award_setting1].present?
      award_setting = 1
      exchange_micro_ticket = 0
    end

    if params[:award_setting2].present?
      award_setting = 2
      exchange_micro_ticket = params[:exchange_micro_ticket]
    end

    if params[:award_setting3].present?
      award_setting = 4
      exchange_micro_ticket = params[:exchange_micro_ticket]
    end

    if params[:award_setting1].present? && params[:award_setting2].present?
      award_setting = 3
      exchange_micro_ticket = params[:exchange_micro_ticket]
    end

    if params[:award_setting1].present? && params[:award_setting3].present?
      award_setting = 6
    end

    if params[:award_setting2].present? && params[:award_setting3].present?
      award_setting = 7
      exchange_micro_ticket = params[:exchange_micro_ticket]
    end

    if params[:award_setting1].present? && params[:award_setting2].present? && params[:award_setting3].present?
      award_setting = 5
      exchange_micro_ticket = params[:exchange_micro_ticket]
    end

    return {published_at: published_at, award_setting: award_setting, exchange_micro_ticket: exchange_micro_ticket}
  end


  private

  def generate_battle_code
    battle_code = MyUtils.generate_code self.id
    self.update_attributes!(battle_code: battle_code)
  end
end

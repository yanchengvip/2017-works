class TaskSetting < ApplicationRecord
  has_many :task_items, -> { where(delete_flag: false) }, dependent: :destroy

  # 任务类型
  TASK_TYPE = {1 => '邀请好友', 2 => '每日参赛', 3 => '更换头像', 4 => '绑定微信', 5 => '赠送微集分', 6 => '能量红包分享'}
  # , 3 => '战场首次出击'
  #跳转页面类型
  Direction_Type = {-1 => '敬请期待', 1 => '订单确认页', 2 => '弹框提示', 3 => '道具回收页', 4 => '兑奖阁', 5 => '宝箱', 6 => '跳转钱包', 7 => '朋友赛场', 8 => '联赛页', 9 => '入场券兑换页', 10 => '赛场页'}
  before_save :set_task_name

  def save_task_items! params
    params && params.each do |item_param|
      self.task_items.create!(item_param.to_hash.slice('prize_type', 'card_id', 'prize_count'))
    end
  end

  def update_task_items!(params)
    params && params.each do |item_param|
      if item_param['id'] && (at_item = self.task_items.where(id: item_param['id'].to_i).first)
        at_item.update!(item_param.to_hash.slice('prize_type', 'card_id', 'prize_count'))
      elsif item_param['id'].blank?
        self.task_items.create!(item_param.to_hash.slice('prize_type', 'card_id', 'prize_count'))
      end
    end
  end

  private
  def set_task_name
    self.task_name = (self.task_type.present?) ? TaskSetting::TASK_TYPE[self.task_type] : '错误类型'
  end


end

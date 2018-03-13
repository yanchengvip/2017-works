class Copy < ApplicationRecord
  validates_presence_of :title, :copy_type

  COPYTYPE = {1 => '卡牌赠送', 2 => '邀请好友', 3 => '分享胜利信息', 4 => '能量红包分享', 10 => '密钥来源', 6 => '大于基值', 7 => '小于基值', 8 => '等于基值', 9 => '最后一轮', 5 => '微信邀请参赛', 11 => '宝箱符充足（每次进入页面）', 12 => '宝箱符不足（每次进入页面）', 13 => '分享链接文案(宝箱邀请)', 14 => '分享页文案(宝箱邀请)', 15 => '规则文案(宝箱)', 16 => '获奖记录累计奖励说明(宝箱)', 17 => '实物分享链接文案(宝箱)', 18 => '实物分享页文案(宝箱)', 19 => '竞赛学院失败', 20 => '竞赛学院成功', 21 => '冠军炫耀', 22 => '邀请得现金', 23 => '联赛炫耀页文案', 24 => '财神活动邀请'}

  STATUS = {1 => '启用', 0 => '禁用'}

  def destroy_copy
    res = {result: false, msg: '删除失败'}
    this_count = Copy.active.where(copy_type: self.copy_type, status: true)&.count
    if self.status && this_count <= 1
      res = {result: false, msg: '删除失败，该类型的可用文案不能少于一个'}
    elsif self.destroy
      res = {result: true, msg: '删除成功'}
    end

    return res
  end

  def self.copy_content copy_type
    Rails.cache.fetch("copy_content:#{copy_type}", expires_in: 300) {
      self.active.where(status: true, copy_type: copy_type).first.as_json&.slice('title', 'content', 'thumbnail')
    }
  end

end

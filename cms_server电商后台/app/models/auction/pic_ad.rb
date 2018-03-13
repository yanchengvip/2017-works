class Auction::PicAd < ApplicationRecord

  LINK_TYPE = { 1 => '专题', 2 => '商品', 3 => '外部链接', 4 => '活动'}
  # validates :sort_field, uniqueness: { scope: :active, message: "排序不能重复"}, if: :not_default?

  def not_default?
    self.sort_field != 0
  end

  def self.auto_shelf
    # pic_ads = self.active
    wait_ups = self.active.where("publish_time <= ? and down_time >= ? and published = 0", Time.now, Time.now)
    wait_ups.update_all(published: true) if !wait_ups.blank?
    wait_downs = self.active.where("down_time <= ? and published = 1", Time.now)
    wait_downs.update_all(published: false) if !wait_downs.blank?
  end


end

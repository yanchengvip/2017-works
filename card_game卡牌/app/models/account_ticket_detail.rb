class AccountTicketDetail < ApplicationRecord
  self.table_name = 'account_ticket_detail'
  self.inheritance_column = ""

  belongs_to :user
  belongs_to :account_ticket
  WEALTHTYPE = {2 => '增加', 1 => "减少"}


  DETAILTYPE = {
    "微机券" =>  1,
    "能量" => 2,
    "宝箱宝符" => 3,
    "免费宝箱宝符" => 4
  }
  TRADTYPE = {
    "购买" => 1,
    "赠送" => 2,
    "消费" => 3,
    "分享" => 4,
    "宝箱领取" => 5,
    "任务领取" => 6,
    "后台赠送" => 7,
    "兑换码兑换" => 11,
    "开宝箱" => 12,
    "登录奖励" => 13
  }

  WEALTHTYPE ={
      1 => '减少',
      2 => '增加'
  }
end

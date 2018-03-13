# 执行 rails db:fortuna_card_init
namespace :db  do
  task fortuna_card_init:  :environment do
    fortuna_card
  end
end


#初始化财神卡牌
def fortuna_card
  #单抢
  Mammon::Card.create(:name => "单抢",:num => "danqiang",:card_type => 1,:percent => 0.01,:effect_percent => 0.1,:effect_times => 1,:delete_flag => 0)
  #嫁祸
  Mammon::Card.create(:name => "嫁祸",:num => "jiahuo",:card_type => 2,:percent => 0.02,:effect_percent => 0.2,:effect_times => 2,:delete_flag => 0)
  #消耗
  Mammon::Card.create(:name => "消耗",:num => "xiaohao",:card_type => 3,:percent => 0.03,:effect_percent => 0.3,:effect_times => 3,:delete_flag => 0)
  #反抢
  Mammon::Card.create(:name => "反抢",:num => "fanqiang",:card_type => 4,:percent => 0.04,:effect_percent => 0.4,:effect_times => 4,:delete_flag => 0)
  #增幅
  Mammon::Card.create(:name => "增幅",:num => "zengfu",:card_type => 5,:percent => 0.05,:effect_percent => 0.5,:effect_times => 5,:delete_flag => 0)
  #互换
  Mammon::Card.create(:name => "互换",:num => "huhuan",:card_type => 6,:percent => 0.06,:effect_percent => 0.6,:effect_times => 6,:delete_flag => 0)
end

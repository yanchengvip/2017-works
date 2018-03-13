namespace :db  do
  task card_init:  :environment do
    generate_cards
  end
end

# 初始化卡牌数据
def generate_cards
  # 顺手牵羊
  Card.create!(name: '夺钥符', card_type: 1, code: '100001', transfer_type: 1, use_aim: 2)
  # 趁火打劫
  Card.create!(name: '摧能符', card_type: 1, code: '100002', transfer_type: 6, use_aim: 2)
  # 连环计
  Card.create!(name: '万夺符', card_type: 1, code: '100003', aim_range: 2, transfer_type: 1, use_aim: 2)
  # 釜底抽薪
  Card.create!(name: '决斗符', card_type: 1, code: '100004', max_key: true, transfer_type: 1, use_aim: 2)
  # 暗度陈仓
  Card.create!(name: '破防符', card_type: 1, code: '100005', ignore_defense: true, transfer_type: 1, use_aim: 2)
  # 李代桃僵
  Card.create!(name: '转伤术', card_type: 2, code: '100006', effect_condition: '100001,100002,100003,100004,100005,100006,100007,100008,100009,100010,100011', transfer_type: 2, transfer_percent: 100, attach_aim: 3)
  # 苦肉计
  Card.create!(name: '还施术', card_type: 2, code: '100007', effect_condition: '100001,100002,100004', transfer_type: 1)
  # 以逸待劳
  Card.create!(name: '消耗术', card_type: 2, code: '100008', effect_condition: '100001,100002,100004', transfer_type: 5)
  # 关门捉贼
  Card.create!(name: '禁锢法令', card_type: 3, code: '100009', is_disable: true, use_aim: 2)
  # 浑水摸鱼
  Card.create!(name: '失控法令', card_type: 3, code: '100010', is_confusion: true, use_aim: 2)
  # 偷梁换柱
  Card.create!(name: '偷天换日', card_type: 3, code: '100011', is_exchange: true, transfer_type: 1, transfer_percent: 100, use_aim: 2)
  # 美人计
  Card.create!(name: '增效法令', card_type: 3, code: '100012', is_double: true)
end

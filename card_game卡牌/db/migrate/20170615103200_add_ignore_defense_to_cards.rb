class AddIgnoreDefenseToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :code, :string, comment: '计谋编码'
    add_column :cards, :ignore_defense, :boolean, default: false, comment: '无视防御 0：否，1:是'
    add_column :cards, :aim_range, :integer, default: 1, comment: '目标范围 1:单体，2:全体'
    add_column :cards, :max_key, :boolean, default: false, comment: '是否最多密钥 0:否，1:是'
    add_column :cards, :use_aim, :integer, default: 1, comment: '使用对象 1:自己，2:对方'
    add_column :cards, :attach_aim, :integer, default: 2, comment: '扣减对象 1:自己，2:对方，3:随机他人'
    add_column :cards, :effect_condition, :string, comment: '生效条件（受到指定卡牌攻击，多选，卡牌id）'
    add_column :cards, :effect_times, :integer, default: 0, comment: '生效次数'
    add_column :cards, :is_disable, :boolean, default: false, comment: '无法使用计谋 0:否，1:是'
    add_column :cards, :disable_time, :integer, default: 0, comment: '无法使用计谋=是时，无法使用计谋的时间（秒）'
    add_column :cards, :is_confusion, :boolean, default: false, comment: '出牌混乱 0:否，1:是'
    add_column :cards, :confusion_time, :integer, default: 0, comment: '出牌混乱=是时，出牌混乱时间（秒）'
    add_column :cards, :is_exchange, :boolean, default: false, comment: '是否互换号码，0:否，1:是'
    add_column :cards, :transfer_type, :integer, default: 0, comment: '转移类型 0:无，1:转移密钥，2:转移计谋'
    add_column :cards, :transfer_percent, :decimal, precision: 3, scale: 2, default: 0, comment: '转移百分比（0～1小数）'
  end
end

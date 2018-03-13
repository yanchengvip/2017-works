class CreateGameTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :game_types, comment: '赛场类型表' do |t|
      t.string :name, default: '', comment: '赛场类型名称'
      t.integer :glory_num, default: 0, comment: '本类型赛场功勋价值'
      t.integer :energy_num, default: 0, comment: '报名所需能量'
      t.integer :product_tag_id, default: 0, comment: '对应重宝商品类型表id'
      t.string :product_ids, default: '', comment: '重宝商品id集合，以英文逗号隔开，如：1,5,6'
      t.integer :order_num, default: 0, comment: '排序'
      t.integer :game_rule_id, default: 0, comment: '赛场规则id'
      t.integer :card_bag_id, default: 0, comment: '卡包id'
      t.text :game_desc, comment: '赛场规则说明'
      t.integer :status, default: 1, comment: '启用状态 1:启用，0:停用'
      t.integer :product_config_type, default: 0, comment: '重宝配置类型（后台记录） 1:随机选择，2:手工配置'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认为0 1:已删除，0:为删除'

      t.timestamps
    end

    add_index :game_types, :product_tag_id
    add_index :game_types, :game_rule_id
    add_index :game_types, :card_bag_id
  end
end

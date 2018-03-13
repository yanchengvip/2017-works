class AddIsGameProductToBattleProducts < ActiveRecord::Migration[5.0]
  def change
    # add_column :battle_products, :is_game_product, :boolean, default: true, comment: '是否赛场商品  默认0:否'
    # add_column :battle_products, :game_product_tag_id, :integer, default: 0, comment: '所属赛场商品类别id'

    # add_column :battle_products, :is_self_game_product, :boolean, default: true, comment: '是否自建赛场商品  默认0:否，对应分类id字段为 product_tag_id'

    # add_column :battle_products, :is_mall_product, :boolean, default: true, comment: '是否兑奖阁商品  默认0:否'
    # add_column :battle_products, :mall_product_tag_ids, :string, default: '', comment: '所属兑奖阁商品类别id,以英文逗号相隔，如：1,2,3'

    # add_column :battle_products, :score_exchange, :boolean, default: true, comment: '是否支持微集分兑换，默认0: 不支持'
    # add_column :battle_products, :score, :integer, default: 0, comment: '兑换所需微集分'

    # add_column :battle_products, :glory_exchange, :boolean, default: true, comment: '是否支持功勋兑换，默认0: 不支持'
    # add_column :battle_products, :glory, :integer, default: 0, comment: '兑换所需功勋'

  end
end

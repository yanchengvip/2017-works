class AddAliasToProductTags < ActiveRecord::Migration[5.0]
  def change
    add_column :product_tags, :alias, :string, default: '', comment: '别名'
    add_column :product_tags, :is_self, :boolean, default: true, comment: '是否支持自建赛场，默认1:支持'
    add_column :product_tags, :max_user_num, :integer, default: 0, comment: '最大人数'
    add_column :product_tags, :product_num, :integer, default: 0, comment: '重宝数量'
    add_column :product_tags, :energy_cost, :integer, default: 0, comment: '建赛场能量消耗'
    add_column :product_tags, :glory_gain, :integer, default: 0, comment: '献祭可得功勋'

    add_index :product_tags, :alias
  end
end

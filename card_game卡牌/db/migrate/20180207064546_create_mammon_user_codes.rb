class CreateMammonUserCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_user_codes, comment: '用户号码记录表' do |t|
      t.string :user_id, comment: '用户ID'
      t.integer :period_id, comment: '期号ID'
      t.text :codes, comment: '幸运号码,多个用逗号隔开'
      t.integer :count, default: 0, comment: '号码变化数量'
      t.string :attack_user_id, comment: '攻击者用户ID'
      t.integer :source_type, default: 0, comment: '号码来源：1=被攻击减少  2=攻击别人获得 3=首次登陆赠送 4=邀请赠送'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end

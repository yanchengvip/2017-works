class CreateMammonPeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_periods, comment: '财神-期次表' do |t|
      t.date :num, comment: '期次'
      t.datetime :pre_begin_time, comment: '准备开始时间，该时间内邀请用户赠送的号码 放到该 期次中'
      # t.datetime :begin_time, comment: '开始时间'
      t.datetime :end_time, comment:'结算时间'
      t.decimal :total_amount, precision: 10, scale: 2, default: 0, comment: '奖品总金额'
      t.decimal :left_amount, precision: 10, scale: 2, default: 0, comment: '剩余奖品金额'
      t.string :code, default: '', comment: '幸运号码'
      t.integer :code_count, default: 0, comment: '号码总数，每日上限10000个，从0000至9999，给用户发放号码不会重复'
      t.integer :left_code_count, default: 0, comment: '剩余号码数量'
      t.integer :red_package_rule_id, default: 0, comment: '红包规则id'
      t.decimal :invite_share_max_amount, precision: 10, scale: 2, default: 0, comment: '邀请分享金额上限'
      t.decimal :day_invite_max_amount, precision: 10, scale: 2, default: 0, comment: '每日邀请好友分享金额上限'
      t.decimal :invite_reward, precision: 10, scale: 2, default: 0, comment: '邀请者邀请好友奖励金额'
      t.decimal :been_invite_reg_reward, precision: 10, scale: 2, default: 0, default: 0, comment: '被邀请好友注册获得奖励金额'
      t.integer :been_invite_receive_time, default: 0, comment: '被邀请者号码及技能牌领取有效期，单位：秒'
      t.integer :first_login_reward, default: 0, comment: '首次登陆送2张卡牌'
      t.integer :rest_time, default: 0, comment: '休整时间，单位：秒'
      t.integer :red_package_time, default: 0, comment: '竞赛结束后触发红包雨时间，单位：秒'
      t.boolean :is_win, default: false, comment: '幸运大奖是否开启'
      t.integer :status, default: false, comment: '状态，默认0:未结算，1:结算中，2:已结算'
      t.boolean :delete_flag, default: false, comment: '是否删除，默认0:未删除'

      t.timestamps
    end

    add_index :mammon_periods, :num
    add_index :mammon_periods, :red_package_rule_id, name: 'mammon_red_packege'
  end
end

class CreateBattles < ActiveRecord::Migration[5.0]
  def change
    create_table :battles, comment: '战役表' do |t|
      t.string :name, comment: '战役名称'
      t.integer :status,default: 1, comment: '战役状态;0:下架,2:待开局,3:开局中,4:已开奖,5:修整中,6:开奖中'
      t.integer :battle_rank, default: 1, comment: '战役场次等级,1:初级场,2:中级场'
      t.datetime :published_at, comment: '战役发布时间'
      t.integer :entrance_ticket_number, default: 0, comment: '入场需消耗券数量'
      t.time :begin_time, comment: '战役开局开始时间段'
      t.time :end_time, comment: '战役开局结束时间段'
      t.integer :award_setting, default: 2, comment: '领奖设置; 1:可领实物,2:可将奖品兑换功勋,3:1或2,4:可领卡牌礼包,5:1或2或3,6:1或3,7:2或3'
      t.integer :exchange_micro_ticket, default: 0, comment: '奖品兑换成功勋数量'
      t.string :battle_code, comment: '战役期号'
      t.text :desc, comment: '活动描述'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end

class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages, comment: '消息表' do |t|
      t.integer :msg_type, default: 0, comment: '类型1 系统发布通知 2 交易消息,建仓消息 3 交易消息, 关注交易信息 4交易消息,平仓结算消息 5交易消息,用户跟随交易信息 6图文发布关注信息,点赞 7图文发布关注,信息评论,8保证金预警'
      t.text :body, comment: '通知内容'
      t.text :user_ids, comment: '用户id列表 all 时推送所有人'
      t.boolean :active, default: true, comment: "软删除字段"

      t.timestamps
    end
  end
end

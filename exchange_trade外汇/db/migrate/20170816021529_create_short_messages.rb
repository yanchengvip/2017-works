class CreateShortMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :short_messages, comment: "短信服务" do |t|
      t.string   "psz_sub_port",  default: "*",  comment: "扩展子号"
      t.integer  "i_mobi_count",  default: 0,    comment: "手机号码个数"
      t.text     "psz_msg",       limit: 65535, comment: "短信内容，最大支持350个字"
      t.text     "psz_mobis",     limit: 65535, comment: "手机号码，用英文逗号(,)分隔，最大1000个号码"
      t.string   "request_ip",    default: "",   comment: "ip地址"
      t.string   "channel_name",  default: "梦网", comment: "通道名"
      t.string   "response_code", default: "",   comment: "返回编码"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
      t.string   "pt_tmpl_id",   comment: "语音模版编号"
      t.string   "msg_type",     comment: "消息类型1：语言验证码2：语音通知（文本语言）3：语音通知（语音id）"
      t.boolean  "is_voice",      default: false,              comment: "是否语音验证码"
      t.index ["request_ip"], name: "index_messages_on_request_ip", using: :btree

      t.timestamps
    end
  end
end

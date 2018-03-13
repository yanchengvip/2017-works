class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, comment: '账号表' do |t|
      t.integer :user_id, default: 0, comment: 'users表ID'
      t.integer :dealer_id, default: 0, comment: '券商表dealers表ID'
      t.integer :dealer_type, default: 0, comment: '关联券商类型dealer_type'
      t.integer :status, default: 1, comment: '账号状态;1:启用,2:禁用'
      t.string :agent_account, comment: '代理账号'
      t.string :mt4_account, comment: 'MT4账号'
      t.string :mt4_group, comment: 'MT4组'
      t.string :name, comment: '姓名'
      t.string :email, comment: '邮箱'
      t.string :phone, comment: '手机号'
      t.string :certificate, comment: '证件类型'
      t.string :certificate_num, comment: '证件号'
      t.string :img_url, comment: '证件图片地址'
      t.string :country, comment: '国家'
      t.string :city, comment: '城市'
      t.string :state, comment: '状态'
      t.integer :leverage, default: 1, comment: '交易杠杆'
      t.decimal :balance, precision: 16, scale: 6, comment: '余额'
      t.decimal :equity, precision: 16, scale: 6, comment: '净值'
      t.decimal :margin, precision: 16, scale: 6, comment: '已用保证金'
      t.decimal :margin_free, precision: 16, scale: 6, comment: '可用保证金'
      t.decimal :credit, precision: 16, scale: 6, comment: '信用'
      t.boolean :is_master, default: false, comment: '是否大师'
      t.string :currency, comment: '货币代码'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :accounts, [:user_id, :dealer_id], :unique => true, name: 'user_dealer_index'
    add_index :accounts, :mt4_account, :unique => true
    add_index :accounts, :phone
  end
end

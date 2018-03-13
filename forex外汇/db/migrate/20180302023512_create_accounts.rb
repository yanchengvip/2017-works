class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, comment: '账户表' do |t|
      t.integer :user_id, default: 0, comment: 'userID'
      t.string :name, comment: '真实姓名'
      t.string :email, comment: '邮箱'
      t.string :phone, comment: '手机号'
      t.integer :status, comment: '状态 1:启用,2：禁用'
      t.integer :typee, default: 0, comment: '用户类型 0普通用户，1交易员'
      t.integer :dealer_id, default: 0, comment: '券商ID'
      t.integer :dealer_type, default: 1, comment: '券商类型：1:虚拟券商，2：约汇网券商'
      t.integer :idnumber_type, default: 1, comment: '证件类型 1=身份证'
      t.string :idnumber, comment: '证件号码'
      t.string :address, comment: '住址'
      t.string :zipcode, comment: '邮编号'
      t.string :city, comment: '市'
      t.string :province, comment: '省'
      t.string :country, comment: '国家'
      t.string :mt4_account, comment: 'MT4账号'
      t.string :mt4_group, comment: 'MT4组'
      t.integer :leverage, default: 1, comment: '交易杠杆'
      t.decimal :balance, default: 0, precision: 16, scale: 5, comment: '余额'
      t.decimal :equity, default: 0, precision: 16, scale: 5, comment: '净值'
      t.decimal :margin, default: 0, precision: 16, scale: 5, comment: '已用保证金'
      t.decimal :margin_free, default: 0, precision: 16, scale: 5, comment: '可用保证金'
      t.text :comment, comment: '备注'
      t.boolean :active, default: true, comment: '软删'


      t.timestamps
    end
    add_index :accounts, :user_id
    add_index :accounts, :phone
  end
end

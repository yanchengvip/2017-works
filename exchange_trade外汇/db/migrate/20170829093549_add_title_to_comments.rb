class AddTitleToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :title, :string, comment: '消息标题'
    add_column :messages, :percent, :decimal, precision: 16, scale: 6, default: 0, comment: '保证金百分数/报警使用'
    add_column :tactics, :status, :integer, default: 0, comment: '状态；0=禁用,1=启用'
    change_column :account_tactics, :dealer_type, :integer, default: 0, comment: '关联券商类型dealer_type'
  end
end

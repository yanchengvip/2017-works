class AddIpToDealers < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :svr_id, :string, comment: '流水号 新增-系统自动生成 删除-必须传入原ID  更新-必须传入原ID'
    add_column :dealers, :svr_name, :string, comment: ' 服务器名称'
    add_column :dealers, :ip, :string, comment: 'ip'
    add_column :dealers, :port, :string, comment: '端口'
    add_column :dealers, :desc, :string, comment: '说明'
  end
end

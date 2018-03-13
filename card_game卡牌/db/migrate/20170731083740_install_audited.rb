#操作日志记录表
class InstallAudited < ActiveRecord::Migration[5.0]
  def self.up
    create_table :audits,comment: '操作日志记录表', :force => true do |t|
      t.column :auditable_id, :integer,comment: '被修改的表ID'
      t.column :auditable_type, :string,comment: '被修改的表名称'
      t.column :associated_id, :integer
      t.column :associated_type, :string
      t.column :user_id, :integer,comment: 'current_user的ID'
      t.column :user_type, :string,comment: 'current_user的表名'
      t.column :username, :string
      t.column :action, :string,comment: '动作名称'
      t.column :audited_changes, :text,comment: '修改的内容'
      t.column :version, :integer, :default => 0
      t.column :comment, :string
      t.column :remote_address, :string
      t.column :request_uuid, :string
      t.column :created_at, :datetime
    end

    add_index :audits, [:auditable_id, :auditable_type], :name => 'auditable_index'
    add_index :audits, [:associated_id, :associated_type], :name => 'associated_index'
    add_index :audits, [:user_id, :user_type], :name => 'user_index'
    add_index :audits, :request_uuid
    add_index :audits, :created_at
  end

  def self.down
    drop_table :audits
  end
end

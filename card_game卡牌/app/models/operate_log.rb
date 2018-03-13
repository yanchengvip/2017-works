class OperateLog < ApplicationRecord
  belongs_to :table, polymorphic: true


  def self.log(admin, exec_action, model, details = nil)
    OperateLog.create(admin_id: admin.id, nickname: admin.nickname, table_type: model.class.to_s,
                     table_id: model.id, exec_action: exec_action, details: details)
  end


end

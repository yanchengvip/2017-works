class AddPublishedToMsgRecords < ActiveRecord::Migration[5.0]
  def change
    begin
      add_column :msg_records, :published, :boolean, default: false, comment: '是否上架，默认0:下架'
    rescue Exception => e
      p e
    end
  end
end

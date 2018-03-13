class CsvFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :csv_files, comment: "统计文件下载记录"  do |t|
      t.integer :user_id, comment: "下载的用户id"
      t.string :url, comment: "文件路径"
      t.string :csv_name, comment: "文件名称"
      t.integer :statistic_type, comment: '统计类型;1:mall_orders统计,2:兑换记录统计,3:card统计',default: 0
      t.date :download_date, comment: "下载日期"
      t.integer :count,comment: '下载次数'
      t.timestamps
    end
  end
end

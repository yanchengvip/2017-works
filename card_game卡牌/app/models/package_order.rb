class PackageOrder < ApplicationRecord
  belongs_to :package
  belongs_to :user
  has_many :package_order_items



  def self.export_excelaa(results)
    xls_report = StringIO.new
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet name: '礼包购买记录'
    style = Spreadsheet::Format.new weight: :bold, size: 14, color: 'black', border: :thin, border_color: 'black', pattern: 1, pattern_fg_color: 'white'
    sheet1.row(0).height = 21
    sheet1.row(0).default_format = style
    sheet1.row(0).concat ['订单编号','用户手机', '礼包购买时间', '销售渠道', '礼包分类', '礼包名称',' 实际支付微集分', '中奖类型' ,'预算节约金额', '开出商品价值（微集份）']
    sheet1.column(9).width = 21
    begin
      results.each_with_index do |r, i|
        sheet1.row(count_row).height = 26
        sheet1[i + 1, 0] = i + 1
        sheet1[i + 1, 1] = r.code
        sheet1[i + 1, 2] = r.user&.mobile
        sheet1[i + 1, 3] = r.created_at.strftime("%Y-%m-%d %H:%m:%S")
        sheet1[i + 1, 4] = Package::SALECHANNEL[r.sale_channel]
        sheet1[i + 1, 5] = r.package&.package_type&.name
        sheet1[i + 1, 6] = r.package&.name
        sheet1[i + 1, 7] = r.total_price
        sheet1[i + 1, 8] = Package::PRIZETYPE[r.package&.prize_type]
        sheet1[i + 1, 9] = r.package_order_items.sum(:price)
      end
    rescue
      Rails.logger.info(e)
    end

    book.write xls_report
    xls_report.string
  end

  def self.export_excel(results)
    require 'csv'
    CSV.generate(:col_sep => "\t", :row_sep => "\r\n") do |csv|
      csv << ["序号",'订单编号','用户手机', '礼包购买时间', '销售渠道', '礼包分类', '礼包名称',' 实际支付微集分', '中奖类型' ,'预算节约金额', '开出商品价值（微集份）']
      results.each_with_index do |r, index|
        csv << [index+1, r.code, r.user&.mobile, r.created_at.strftime("%Y-%m-%d %H:%m:%S"), Package::SALECHANNEL[r.sale_channel], r.package&.package_type&.name, r.package&.name, r.total_price, Package::PRIZETYPE[r.package&.prize_type], r.package_order_items.sum(:price)]
      end
    end.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => "?")
  end


end

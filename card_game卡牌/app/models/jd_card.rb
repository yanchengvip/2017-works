class JdCard < ApplicationRecord

  # excle导入商品
  def self.import_from_excel excel_url
    xlsx = Roo::Spreadsheet.open(excel_url)
    xlsx.each_with_index do |row, i|
      next if i == 0
      code = row[0]&.strip
      password = row[1]&.strip
      price = row[2]
      if code.blank? || password.blank? || price.blank?
        Rails.logger.info('数据为空，该卡创建失败' + "code:#{row[0]}-password: #{row[1]}-price: #{row[2]}")
        next
      end

      if JdCard.find_by(code: code).present?
        Rails.logger.info('卡号重复，该卡创建失败' + "code:#{row[0]}")
        next
      end

      begin
        JdCard.create!(code: code, password: password, price: price)
      rescue Exception => e
        Rails.logger.info('*'*10 +'导入失败' + e.to_s)
      end

    end
  end


end

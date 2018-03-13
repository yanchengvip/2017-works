require 'csv'
module DownloadCsv
  extend ActiveSupport::Concern
  module ClassMethods

    def to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end

    def custom_save_csv file_path,datas, *headers
      csv_string = CSV.generate do |csv|
        headers.each do |h|
          csv << h
        end
        datas.each do |data|
          csv << data
        end
      end
      # .encode('utf-8', :invalid => :replace, :undef => :replace, :replace => "?")
      # binding.pry
      File.open(file_path, "w") do |file|
        file.syswrite "\xEF\xBB\xBF"
        file.syswrite csv_string
      end
    end
  end

  module InstanceMethods
  end

end

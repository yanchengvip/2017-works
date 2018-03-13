module DownloadCsv
  module ClassMethods
    def to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names).map{|x| (x.is_a? String) ? x.gsub(",", "，") : x}
        end
      end
    end
  end

  module InstanceMethods
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

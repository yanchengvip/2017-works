module MyUtils

  def self.generate_uuid
    #UUIDTools::UUID.timestamp_create().to_s
    UUIDTools::UUID.random_create().to_s
  end


  def self.generate_random *args
    if args.present?
      Time.new.strftime("%Y%m%d%H%M%S") + args[0].to_i.to_s

    else
      Time.new.strftime("%Y%m%d%H%M%S")
    end

  end


  def self.generate_code *args
    Time.new.strftime("%Y%m%d%H%M%S") + args[0].to_i.to_s
  end


  def self.time_format date_time
    if date_time.present?
      date_time = date_time.strftime('%Y-%m-%d %H:%M')
    else
      date_time = ''
    end
    return date_time
  end


  def self.time_random
    Time.new.strftime("%Y%m%d%H%M%S") + rand(999999).to_s
  end

end

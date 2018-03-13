module MyUtils

  class << self

    def generate_uuid
      UUIDTools::UUID.random_create().to_s
    end

    #生成时间随机数，默认到秒
    def generate_time_random *args
      args[0] = 0 if args[0].nil?
      Time.new.strftime("%Y%m%d%H%M%S") + generate_num_random(args[0])
    end

    #生成纯数字随机数，默认4位数字
    def generate_num_random *args
      args[0] = 4 if args[0].nil?
      Array(0..9).sample(args[0].to_i).join()
    end

    #时间格式化
    def time_format date_time
      if date_time.present?
        date_time = date_time.strftime('%Y-%m-%d %H:%M')
      else
        date_time = ''
      end
      return date_time
    end


  end

end

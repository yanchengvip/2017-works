module AllocatingPrizes
  module ClassMethods
    # count , data [array], rules [array]; count:宝箱抽奖次数，
    #data奖品信息 [[1, 100, 10, 1] ] [商品ID， 件数， 单价, 类别1:幸运大奖 只能有一个，2:稀有，3:普通]
    #rules 分配规则 [ [30, 20], [60, 50], [10, 30]]
    # return [ [[商品ID1, 单价1], [商品ID1, 单价1]], [[商品ID1, 单价1], [商品ID1, 单价1]]], size = count
    # 100, [[1, 800, 10],[2, 100, 20],[3, 60, 30],[4, 39, 40],[4, 1, 500]], [[100, 100]]
    # cant_percent 大奖出现位置
    def exchange(count, data, rules, min, max, cant_percent)
      res = []
      big_prize = data.select{|x| x[3] == 1}
      data = data.select{|x| x[3] != 1}.sort{|x, y| x[2] <=> y[2]}

      product_use_count = Hash.new 0

      total_price = data.inject(0){|sum, x| sum += x[1] * x[2]}

      rules.each_with_index do |r, r_index|
        per = r[1] / 100.0
        # r_index 为抽奖阶段规则 下标 0 代表第一阶段
        # r_count 为抽奖阶段规则 每次需要产生的抽奖次数
        if r_index == (rules.size - 1) #最后抽奖阶段 抽奖次数为 总次数 - 已经产生的抽奖次数
          r_count = count - res.size
        else
          r_count = ( r[0]  / 100.0 * count).floor #每阶段抽奖次数为 抽奖百分比 * 总次数
        end

        per_data = [] #每阶段抽奖数据

        #获取该阶段的 每个商品抽奖次数
        data.each do |d|
          use_count =[ (d[1] * per).floor,  d[1] - product_use_count[d[0]] ].min
          # if use_count == 0 &&  d[1] - product_use_count[d[0]] > 0
          #   use_count = d[1] - product_use_count[d[0]]
          # end
          use_count = [r_count * max - per_data.size,  use_count].min #当前阶段缺少最大抽奖次数 与 当前商品可用抽奖次数 取最小值
          if use_count > 0
            _t = Array.new(use_count , d[0])
            product_use_count[d[0]] += use_count
            per_data +=  _t
          end

          if per_data.size >= r_count * max
            break
          end
        end

        #如果取得的商品数量 小于 需要的抽奖次数 ， 则从单价最小的商品中依次抽取
        if per_data.size < r_count
          data.each do |x|
            if x[1] - product_use_count[x[0]] + per_data.size  >= r_count
              product_use_count[x[0]] += r_count - per_data.size
              per_data += Array.new(r_count - per_data.size, x[0])

            else
              product_use_count[x[0]] += x[1] - product_use_count[x[0]]
              per_data += Array.new(x[1] - product_use_count[x[0]], x[0])
            end
            if per_data.size >= r_count
              break
            end
          end
        end

        #如果最后一轮， 则将所有商品放到 奖池中
        if  r_index == (rules.size - 1)
          data.each do |x|
            if x[1] - product_use_count[x[0]] > 0
              per_data +=  Array.new(x[1] - product_use_count[x[0]], x[0])
              product_use_count[x[0]] += x[1] - product_use_count[x[0]]
            end
          end
        end


        _res = []

        per_data = per_data.shuffle
        (0...r_count).each do |i|
          _res[i] = [per_data.pop]
        end
        hash_res = {}
        _res.each_with_index do |x, i|
          if x.size < max
            hash_res[i] = x.size
          end
        end
        while(s = per_data.pop)
          k = hash_res.keys.sample
          if k
            _res[k] << s
            hash_res[k] += 1
            if hash_res[k] >= max
              hash_res.delete(k)
            end
          else
            p "***"* 100
          end
        end

        #将当前阶段抽奖数据 放到 总奖池中
        res += _res.shuffle
      end

      min_big_prize_size =  (count * cant_percent / 100.0).floor

      big_prize_size = count
      while big_prize_size >= count
        big_prize_size = min_big_prize_size + rand(count - min_big_prize_size)
      end

      res[big_prize_size] << big_prize[0][0]
      res
    end

    def test_exchange res, count, data, rules, min, max, cant_percent
      if res.size != count
        return "抽奖总数不一致#{res.size} #{count}"
      end
      if res.flatten.size != data.inject(0) { |sum, x|  sum += x[1] }
        return "奖品总数不一致#{res.flatten.size} #{data.inject(0) { |sum, x|  sum += x[1] }}"
      end
      res_flatten = res.flatten
      data.each do |x|
        if x[1] != res_flatten.select{|d| d == x[0]}.size
          return "#{x[0]}商品数码不一致#{x[1]}  #{res_flatten.select{|d| d == x[0]}.size}"
        end
      end
      res.each do |x|
        if x.size < min
          return "单次抽奖数量小于最小值#{min}"
        end
        if  x.size > max
          return "单次抽奖数量大于最大值#{max}"
        end
      end

      return true
    end

    def test_chest count, data, rules, min, max, cant_percent
      res = exchange(count, data, rules, min, max, cant_percent)
      s = test_exchange(res.dup, count, data.dup, rules.dup, min, max, cant_percent)
      return {tag: s, res: res}
    end

    def test_init total
      i = 0
      result = []
      while(i < total)
        i += 1
        max = 1 + rand(10)
        count = 10 ** (1+rand(4))
        c = 1+rand(10)
        data = Array.new
        c = 1
        while data.inject(0) { |sum, x| sum += x[1] } < 2 * count
          data << [c, 1 + rand(max * count / 2), 1 + rand(10000) ]
          c += 1
        end
        data << [c, 1 , 100001 ]
        a1 = rand(50) + 1
        a2 = 0
        while a2 == 0
          a2 = rand(100 - a1)
        end
        rules = [[30, 30],[60, 60],[10, 10]]
        rules = [[a1, 30],[a2, 60],[100 - a1 - a2 , 10]]
        p data
        p rules
        begin
          res = exchange(count, data.dup, rules.dup, 1, 10)
          s = test_exchange(res.dup, count, data.dup, rules.dup)
          if s != true
            result << [res, count, data, rules, s]
          end
        rescue Exception => e
          result << [e, count, data, rules]
          p e
        end
      end
      return result
    end
  end

  module InstanceMethods
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

module JackpotsHelper

  def prize_level(level)
    case level
    when 1
      res = '普通'
    when 2
      res = '稀有'
    when 3
      res = '幸运大奖'
    else
      res = ''
    end

    return res
  end

  def prize_name(jackpot_product)
    case jackpot_product.type
    when '1'
      res = jackpot_product.count.to_s + '能量'
    when '2'
      res = jackpot_product.count.to_s + '功勋'
    when '3'
      res = jackpot_product.count&.to_s + jackpot_product.product&.name&.to_s
    when '4'
      res = jackpot_product.product&.name
    else
      res = ''
    end

    return res
  end

  def league_status game_league
    res = ''
    if game_league.league_begin.blank?
      res = '未设置开启时间'
    elsif Time.now < game_league.league_begin
      res = '等待开启'
    elsif Time.now >= game_league.league_begin && Time.now <= game_league.league_end
      res = '开启中'
    elsif Time.now >= game_league.league_end
      res = '已结束'
    end
    return res
  end

end

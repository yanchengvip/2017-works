module BattlesHelper

  #修改战役  战役等级设置
  def battle_rank_is_checked radio_val,br_val
    if radio_val.to_i == br_val.to_i
      return 'checked'
    end

  end

  #修改战役  领奖设置
  def award_setting_is_checked check_val,award_val
    check_val = check_val.to_i
    award_val = award_val.to_i

    if check_val == 1 && [1,3,5,6].include?(award_val)
      return 'checked'
    end

    if check_val == 2 && [2,3,5,7].include?(award_val)
      return 'checked'
    end

    if check_val == 3 && [3,5,6,7].include?(award_val)
      return 'checked'
    end

  end

end

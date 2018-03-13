module BattleRulesHelper

  def battle_rule_status_name status
     case status.to_i
       when 0
         name = '启用'
       when 1
         name = '禁用'
       else
        name = '无'
     end
    return name
  end
end

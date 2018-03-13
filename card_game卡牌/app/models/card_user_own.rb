class CardUserOwn < ApplicationRecord
  self.table_name = "card_user_own"

  belongs_to :user

  def self.push_data(params)
    res = MsgRecord.apiClient("/card-service-web/card/updateRedisMycards", {userId: params[:userId], cardId: params[:cardId], num: params[:num]})

    return res
  end

  def self.give_energy params
    res = MsgRecord.apiClient("/card-service-web/mainBattleField/updateEnergyNum", {userId: params[:userId], num: params[:num]})

    # ('2U17071913505500010', '2U17071914073700010')
    return res
  end

end



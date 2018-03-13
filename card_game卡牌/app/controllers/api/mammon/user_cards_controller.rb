class Api::Mammon::UserCardsController < Api::ApplicationController

  #用户持有技能牌及数量
  def index
    if period =  Mammon::Period.current
      cards = Mammon::Card.active.order(:id)
      mammon_user_cards = Mammon::UserCard.where(:user_id => current_user.id, period_id: period.id)

      render json:
      {
        "execResult" => true,
        "execMsg" => "",
        "execData" => {
          cards: cards.as_json.map{|card|
            card.merge(count: mammon_user_cards.select{|x| x.card_id == card["id"]}.first&.count.to_i )
          }
        },
        "execDatas" => [],
        "execErrCode" => "200"
      }
    else
      render json:
      {
        "execResult" => false,
        "execMsg" => "财神活动未开启",
        "execData" => {
        },
        "execDatas" => [],
        "execErrCode" => "500"
      }
    end
  end

end

class FxPriceChannel < ActionCable::Channel::Base


  def connect
    #self.current_user = current_user

  end

  def subscribed
    #identified_by :current_user
    stream_from 'fx_price_channel'

  end

  def unsubscribed

  end


end
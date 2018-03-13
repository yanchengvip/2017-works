class AlertCardYydl < ActiveRecord::Migration[5.0]
  def change
    yydl = Card.find_by(code: '100008')
    yydl&.update_attributes(transfer_type: 5)
  end
end

class AlterCardData < ActiveRecord::Migration[5.0]
  def change
    chdj = Card.find_by(code: '100002')
    chdj&.update_attributes(transfer_type: 6)

    yydl = Card.find_by(code: '100008')
    yydl&.update_attributes(name: '以逸待劳', is_disable: false)

    mrj = Card.find_by(code: '100012')
    mrj&.update_attributes(delete_flag: false)
  end
end

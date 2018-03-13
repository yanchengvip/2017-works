class ChestRecordItemJob < ApplicationJob
  queue_as :chest_order_item_queue

  def perform(chest_record_id)
    c = ChestRecord.find(chest_record_id)
    c.with_lock do
      if c.init_chest_record_item_status == 0
        c.update!(init_chest_record_item_status: 1)
        c.init_chest_record_item
      end
    end
  end
end

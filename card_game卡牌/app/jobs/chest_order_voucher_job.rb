class ChestOrderVoucherJob < ApplicationJob
  queue_as :chest_order_voucher_queue

  def perform(chest_record_id)
    begin
      ChestRecord.find(chest_record_id).send_voucher_to_ihaveu
    rescue Exception => e
    end
  end
end

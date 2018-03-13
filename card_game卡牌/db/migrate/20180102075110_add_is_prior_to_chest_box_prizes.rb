class AddIsPriorToChestBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_box_prizes, :is_prior, :boolean, default: false, comment: '是否优先展示，默认0:否'
  end
end

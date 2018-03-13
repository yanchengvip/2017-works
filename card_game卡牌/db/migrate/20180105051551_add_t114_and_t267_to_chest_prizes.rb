class AddT114AndT267ToChestPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_prizes, :t114, :string, deafult: "", comment: "奖品图片切图114X114"
    add_column :chest_prizes, :t267, :string, deafult: "", comment: "奖品图片切图267X267"
  end
end

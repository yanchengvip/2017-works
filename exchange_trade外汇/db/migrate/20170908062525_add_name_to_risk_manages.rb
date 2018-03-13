class AddNameToRiskManages < ActiveRecord::Migration[5.1]
  def change
    add_column :risk_manages, :name, :string,comment: '名称'
  end
end

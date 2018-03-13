class AddOperatorIdToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :operator_name, :string, comment: '操作员名称'
    add_column :cards, :operator_id, :integer, default: 0, comment: '操作员ID'
  end
end

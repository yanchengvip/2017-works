class CreateAuctionPromotionActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_promotion_activities, comment: "促销活动" do |t|
      t.string :name, comment: "活动名称", default: ""
      t.datetime :declar_begin, comment: "活动申报开始时间"
      t.datetime :declar_end, comment: "活动申报结束时间"
      t.datetime :promotion_begin, comment: "活动结束时间"
      t.datetime :promotion_end, comment: "活动结束时间"
      t.string :label, comment: "促销标签", default: ""
      t.string :description, comment: "活动描述", default: ""
      t.text :requirement, comment: "活动规则/要求"
      t.decimal :discount, precision: 10, scale: 2, comment: "供应商最新结算价最低降价幅度", default: 0
      t.integer :discount_type, comment: "优惠方式 1 连拍折扣， 2 每满XX减XX， 3 满减", default: 0
      t.integer :multiple_sales_count, comment: "连拍折扣-连拍件数", default: 0
      t.decimal :multiple_sales_discount, precision: 10, scale: 2, comment: "连拍折扣-连拍折扣 0-10 如9.9表示9.9折", default: 0
      t.decimal :price_more, precision: 15, scale: 2, comment: "满减-满", default: 0
      t.decimal :price_off, precision: 15, scale: 2, comment: "满减-减多少", default: 0
      t.decimal :pre_price_more, precision: 15, scale: 2, comment: "每满XX减XX-满", default: 0
      t.decimal :pre_price_off, precision: 15, scale: 2, comment: "每满XX减XX-减多少", default: 0
      t.decimal :pre_discount_total, precision: 15, scale: 2, comment: "每满XX减XX-最大优惠值", default: 0
      t.decimal :rate_of_margin, precision: 10, scale: 2, comment: "统一毛利率", default: 0
      t.integer :status, comment: "审批状态 0-未审批， 1 待审批， 2驳回， 3通过", default: 0
      t.integer :user_id, comment: "运营ID"
      t.boolean :active, comment: "软删字段 true 已删除", default: true

      t.timestamps
    end
  end
end

class Recovery < ApplicationRecord
  STATUS = {0 => '启用', 1 => '禁用'}
  belongs_to :chest_prize
  has_many :rule_recover_history_prices, -> { where("day > ?", (Date.today - 6).to_s).order('id asc')}, class_name: 'RecoverHistoryPrice', primary_key: 'recovery_id'

  has_many :recovery_items
  has_many :recoveries
  belongs_to :chest_prize

  self.xml_options = {
      :only => ["id", "admin_id", "total_cost", "time_begin", "time_end",  "chest_prize_type", "chest_prize_id", "total_count", :status, :name ].freeze,
      include: {
          rule_recover_history_prices: {
              only:  ["price", "day"]
          },
          chest_prize: {
            only: ["id", "name",  "thumbnail", "t114", "t267"]
          }
      }
  }.freeze

  def self.open_recovery
    where(is_rule: true, status: 0).each do |x|
      begin
        x.open_recovery
      rescue Exception => e

      end
    end
  end

  def open_recovery
    self.recoveries.create(admin_id: self.id, total_cost: self.total_cost, time_begin: Time.now.at_beginning_of_day + (self.time_begin - self.time_begin.at_beginning_of_day), time_end: Time.now.at_beginning_of_day + (self.time_end - self.time_end.at_beginning_of_day), is_rule: false, chest_prize_id: self.chest_prize_id, total_count: 0, actual_cost: 0,  status: 0, sort_index: self.sort_index, day: Date.today.to_s, is_check_cash: false, name: self.name, chest_prize_type: self.chest_prize_type)
  end

  def check_cash day
    self.with_lock do
      if self.is_check_cash == false
        self.update!(is_check_cash: true)
        prize_count = recovery_items.sum(:count)
        if prize_count > 0
          rule_recover_history_price = self.rule_recover_history_prices.create!(price: ((self.total_cost * 100 / prize_count).floor / 100.0).round(2), day: day)
          recovery_items.group_by{|x| x.user_id}.each do |user_id, data|
            current_user = User.find(user_id)
            account_ticket = current_user.account_ticket.lock!
            AccountTicketBalanceDetail.create!( user_id: user_id, fund: rule_recover_history_price.price * data.sum(&:count), trad_type: 3)
            account_ticket.update!(balance: account_ticket.balance + rule_recover_history_price.price * data.sum(&:count) )
          end
        else
          rule_recover_history_price = self.rule_recover_history_prices.create!(price: self.total_cost, day: day)
        end
      end
    end
  end

  def self.check_cash(day = nil)
    day = Date.today.to_s if day.blank?
    where(day: day, is_rule: false).each do |x|
      begin
        x.check_cash(day)
      rescue Exception => e
      end
    end
  end
end

# class AppVersion < ApplicationRecord
class AppVersion < ActiveRecord::Base
  self.table_name = 'app_version'
  include ActAsActivable
  def destroy
    update_attribute(:delete_flag, true)
    run_callbacks :destroy
    freeze
  end

  validates :desc, presence: true

  before_save :set_time

  private
  def set_time
    if self.new_record?
      self.create_time = self.update_time = Time.now
    else
      self.update_time = Time.now
    end
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  audited
  class_attribute :xml_options
  attr_accessor :xml_options
  include ActAsActivable
  def destroy
    update_attribute(:delete_flag, true)
    run_callbacks :destroy
    freeze
  end
end

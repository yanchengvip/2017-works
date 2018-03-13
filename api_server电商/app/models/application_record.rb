class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  class_attribute :xml_options
  attr_accessor :xml_options
  include ActAsActivable
end

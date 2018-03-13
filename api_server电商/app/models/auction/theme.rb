class Auction::Theme < ApplicationRecord
  self.xml_options = { :only =>  [:id, :title, :subtitle, :pic, :products, :link_url, :search_params, :down_time, :rank, :price_gt, :price_lt].freeze }.freeze

  def self.app_bar_xml_options
    { :only =>  [:id, :title, :pic,  :link_url] .freeze }.freeze
  end
end

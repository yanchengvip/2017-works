class Auction::Brand < Base

  self.xml_options = { :only => [ :id, :name, :chinese, :description, :pic, :recommend, :initial].freeze }.freeze
  def self.showxml_options
    {
      :only => [:name, :title, :keywords, :year, :description,:country].freeze,
      :include => {
        :country => {
          :only => [ :id, :name].freeze,
        }
      }
    }.freeze
  end

  def self.list params
    post("/user-service/brands/list/", params)
  end
  def self.detail params
    post("/user-service/brands/detail", params)
  end
  def self.detail_ids params
    post("/user-service/brands/listBrandsByBrandIds",params)
  end
end

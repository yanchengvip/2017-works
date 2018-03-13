# ## Schema Information
#
# Table name: `areas` # 地区表
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`area_id(上级地区id)`**     | `integer`          | `default(0)`
# **`name(名称)`**    | `string(255)`      |
# **`active(软删除标志)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#

class Area < ApplicationRecord
  has_many :areas
  require 'csv'
  def self.init_from_csv
    provinces = CSV.read("./document/province.csv")
    cities = CSV.read("./document/city.csv")
    towns = CSV.read("./document/town.csv")

    provinces.each do |province|
      area_province = Area.create(name: province[1])
      cities.select{|x| x[1] == province[0]}.each do |city|
        area_city = area_province.areas.create(name: city[2])
        towns.select{|x| x[1] == city[0]}.each do |town|
          area_city.areas.create(name: town[2])
        end
      end
    end
  end
end

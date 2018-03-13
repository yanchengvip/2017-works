class Api::WisdomConnection < ApplicationRecord
  self.abstract_class = true    #共用连接池，减少数据库连接的消耗
  establish_connection DATABSECONFIG["wisdom"]  #DatabaseCnf是一个类，它用来读取database.yml配置。
end

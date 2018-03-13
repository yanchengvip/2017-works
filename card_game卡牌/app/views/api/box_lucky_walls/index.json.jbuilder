json.execResult true
json.execMsg '奖品墙'
json.execErrCode 200
json.execDatas do
  json.main_products do
    json.title @main_product&.title #奖品墙标题
    json.name @main_product&.name
    json.content @main_product&.content
    json.price @main_product&.price.to_i
    json.promotion_words @main_product&.promotion_words #推广文字
    # json.image FASTDFSCONFIG[:fastdfs][:tracker_url] + @main_product&.image.to_s
    json.image @main_product&.image.to_s
    json.t114 @main_product&.t114.to_s
    json.t267 @main_product&.t267.to_s
  end
  json.other_products do
    json.array! @other_products do |pro|
      json.name pro.name
      json.content pro.content
      json.price pro.price.to_i
      json.is_over pro.is_over
      json.promotion_words pro.promotion_words
      # json.image FASTDFSCONFIG[:fastdfs][:tracker_url] + pro.image.to_s
      json.image pro.image.to_s
      json.t114 pro.t114.to_s
      json.t267 pro.t267.to_s
    end
  end

end

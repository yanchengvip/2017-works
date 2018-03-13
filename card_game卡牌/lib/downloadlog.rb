#  #根据nginx 69 70 的日志解析每天app下载量并生成csv文件


#  h = Hash.new
#  files = ["/Users/yczhao/logs/access.action.ihaveu.com.log-2017-12-01-1512143941",
#  "/Users/yczhao/logs/access.action.ihaveu.com.log-2017-12-02-1512230341",
#  "/Users/yczhao/logs/access.action.ihaveu.com.log-2017-12-03-1512316741",
#  "/Users/yczhao/logs/access.action.ihaveu.com.log-2017-12-04-1512403141",
#  "/Users/yczhao/logs/70/access.action.ihaveu.com.log-2017-12-01-1512143941",
#  "/Users/yczhao/logs/70/access.action.ihaveu.com.log-2017-12-02-1512230341",
#  "/Users/yczhao/logs/70/access.action.ihaveu.com.log-2017-12-03-1512316741",
#  "/Users/yczhao/logs/70/access.action.ihaveu.com.log-2017-12-04-1512403141",
#  ]
# tag = Hash.new
# files.each do |path|
#  res = []
#   f = File.open path

#   f.readlines.each do |x|
#     if x.include?("/downloadapp/card/android/CardGame.apk") && tag[x[0..14]].blank?
#       tag[x[0..14]] = 1
#       res << x
#     end
#   end


#   res.each do |s|
#     from =  s.scan(/ld\/\?from=([\w]+)/).first
#     unless from.blank?
#       t = s.scan(/\[([\w\W]+)\]/).first&.first
#       if h[t[0,11]]
#         h[t[0,11]][from.first] +=  1
#       else
#         p t[0,11]
#         h[t[0,11]] = Hash.new 0
#         h[t[0,11]][from.first] +=  1
#       end
#     end
#   end
# end
# f= File.open "res.csv", "w+"
# title = ["day"] + h.values.map{|x| x.keys}.flatten.uniq.sort + ["\r\n"]
# f.write title.join(",")
# h.each do |key, v|
#   r = [key]
#   title.each_with_index do |name, index|
#     unless index == 0
#       r[index] = v[name]
#     end
#   end
#   r << "\r\n"
#   p r
#   f.write r.join(",")
# end
# f.close






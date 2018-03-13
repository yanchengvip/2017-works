class Auction::ExchangeRate < ApplicationRecord


  def self.get_exchange_rate_price(from, to, day)
    exchange_rate = ExchangeRate.where(day: day, from: from, to: to).last
    exchange_rate = ExchangeRate.where(day: day, from: from, to: to).order(" day desc, created_at desc").first unless exchange_rate
    exchange_rate&.price
  end

  #外管局
  def self.get_exchange_rate_from_safe
    url = "http://www.safe.gov.cn/AppStructured/view/project_syRMBQuery.action"
    res = Faraday.new.get(url)
    doc = Nokogiri::HTML(res.body)
    get_falg = false
    doc.css(".list1 tr").each do |tr|
      data = tr.css("td").map{|x| x.text.strip}
      if data[1] == '美元' && data[3] == '人民币'
        get_falg = true
        Auction::ExchangeRate.create(from: "USD", to: "CNY", amount: 1, price: (data[2].to_f / data[0].to_f).round(4), day: Date.today.to_s)
      end
    end
    unless get_falg
      get_exchange_rate_from_bankofchina
    end
  end

  # 中行 只获取美元
  def self.get_exchange_rate_from_bankofchina
    url = "http://srh.bankofchina.com/search/whpj/search.jsp"
    res = Faraday.new.post(url,{pjname: 1316, erectDate: "", nothing: ""})
    doc = Nokogiri::XML(res.body)
    doc.css(".BOC_main tr").each do |tr|
      data = tr.css("td").map{|x| x.text.strip}
      if data[0] == '美元' && !Auction::ExchangeRate.where(created_at: Time.parse(data[7])).exists?
        Auction::ExchangeRate.create(from: "USD", to: "CNY", amount: 1, price: (data[5].to_f / 100).round(4), created_at: Time.parse(data[7]), day: Date.today.to_s)
      end
    end
  end

  def self.get_all_exchange_rate_from_bankofchina
    url = "http://srh.bankofchina.com/search/whpj/search.jsp"
    pjnames = ["1314", "1315", "1316", "1317", "1318", "1319", "1375", "1320", "1321", "1322", "1323", "1324", "1325", "1326", "1327", "1328", "1329", "1330", "1331", "1843", "2890", "2895", "1370", "1371", "1372", "1373", "1374", "3030", "3253", "3899", "3900", "3901", "4418", "4560"]
    pjcnnames = ["英镑", "港币", "美元", "瑞士法郎", "德国马克", "法国法郎", "新加坡元", "瑞典克朗", "丹麦克朗", "挪威克朗", "日元", "加拿大元", "澳大利亚元", "欧元", "澳门元", "菲律宾比索", "泰国铢", "新西兰元", "韩元", "卢布", "林吉特", "新台币", "西班牙比塞塔", "意大利里拉", "荷兰盾", "比利时法郎", "芬兰马克", "印尼卢比", "巴西里亚尔", "阿联酋迪拉姆", "印度卢比", "南非兰特", "沙特里亚尔", "土耳其里拉"]
    pjnames.each do |pjname|
      res = Faraday.new.post(url,{pjname: pjname.to_i, erectDate: "", nothing: ""})
      doc = Nokogiri::XML(res.body)
      doc.css(".BOC_main tr")[1..-1].each do |tr|

        data = tr.css("td").map{|x| x.text.strip}
        p data
        if pjcnnames.include?(data[0]) && !Auction::ExchangeRate.where(from: data[0], created_at: Time.parse(data[7])).exists?
          Auction::ExchangeRate.create(from: data[0], to: "CNY", amount: 1, price: (data[5].to_f / 100).round(4), created_at: Time.parse(data[7]), day: Date.today.to_s)
        end
      end
    end
  end
end

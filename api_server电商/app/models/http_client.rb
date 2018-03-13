require 'rest-client'
module HttpClient
  def base
    Setting.java_server["base"]
  end

  def httprb
    RestClient
  end

  #小驼峰转小写underscore('ActiveModel')         # => "active_model"
  # {ActiveModel: "123"}
  # {ActiveModel: {ActiveModel2: "123"}}
  def params_key_underscore(params)
    return params.map{|x| params_key_underscore(x) } if  params.is_a? Array
    # return params.map{|x| params_key_underscore(x) } unless params.is_a? Hash
    if params.is_a? Hash
      t = {}
      params.each do |key, value|
        if value.is_a?(Hash)
          t[key.to_s.underscore] = params_key_underscore(value)
        elsif value.is_a?(Array)
          t[key.to_s.underscore] = value.map{|x| params_key_underscore(x)}
        else
          t[key.to_s.underscore] = value
        end
      end
      t
    else
      params
    end
  end

  #小写转小驼峰camelize('active_model', false)         # => "activeModel"
  def params_key_camelize(params)
    # return params if params.is_a? String
    return params.map{|x| params_key_camelize(x) } if  params.is_a? Array
    # return params.map{|x| params_key_camelize(x) } unless params.is_a? Hash
    if params.is_a? Hash
      t = {}
      params.each do |key, value|
        if value.is_a?(Hash)
          t[key.to_s.camelize(:lower)] = params_key_camelize(value)
        elsif value.is_a?(Array)
          t[key.to_s.camelize(:lower)] = value.map{|x| params_key_camelize(x)}
        else
          t[key.to_s.camelize(:lower)] = value
        end
      end
      t
    else
      params
    end
  end

  # def get(path, payload, get_header = {})
  #   request(path, get_header) do |url, header|
  #     params = header.delete(:params)
  #     httprb.get(url, {params: payload, headers: header})
  #   end
  # end

  def post(path, payload={}, post_header = {})
    request(path, post_header) do |url, header|
      Rails.logger.info("*"*50)
      Rails.logger.info(url)
      Rails.logger.info({params: params_key_camelize(payload.as_json).to_json})

      res = httprb.post(url, {params: params_key_camelize(payload.as_json).to_json}, header)
      Rails.logger.info(res)
      Rails.logger.info("end")
      res
    end
  end

  def request(path, header = {}, &_block)
    url_base = header.delete(:base) || base
    # header['content_type'] ||= 'json'
    # header['accept'] ||= 'json'
    response = yield("#{url_base}#{path}", header)

    parse_response(response) do |data|
      data['data'] =  params_key_underscore data['data']
      data
    end
  end

  def parse_response(response)
    data = (JSON.parse response.body.to_s).with_indifferent_access
    # OpenStruct.new(data)
    yield(data)
  end
end

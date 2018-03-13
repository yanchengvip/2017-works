class Hash
  def slice_as_json options = nil
    options = options.with_indifferent_access if options
    data = self
    if options
      if options[:only]
        data = data.slice(*options[:only])
      end
      if options[:include]
        options[:include].keys.each do |key|
          if options[:include][key][:only] && data[key]
            # if data[key]
            if data[key].is_a? Array

              data[key] = data[key].map{|x| x.slice_as_json(options[:include][key])}
            else
              data[key] = data[key].slice_as_json(options[:include][key])
            end
          end
        end
      end
      data.as_json
    else
      data.as_json
    end
  end
end

class ActiveSupport::TimeWithZone
  #Changing the as_json method to remove the milliseconds from TimeWithZone to_json result (just like in Rails 3)
  def as_json(options = {})
      if ActiveSupport::JSON::Encoding.use_standard_json_time_format
          xmlschema
      else
          %(#{time.strftime("%Y/%m/%d %H:%M:%S")} #{formatted_offset(false)})
      end
  end

  def xmlschema(fraction_digits=0)
    fraction_digits = fraction_digits.to_i
    s = strftime("%F %T")
    # if fraction_digits > 0
    #   s << strftime(".%#{fraction_digits}N")
    # end
    # s << (utc? ? '' : strftime("%:z"))
  end
end

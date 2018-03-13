class Hash
  def self.sum(a, b)
    b.each do |k, v|
      if a[k].blank?
        a[k] = v
      else
        a[k] += v
      end
    end
    a
  end
end

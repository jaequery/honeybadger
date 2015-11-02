class NilClass
  def [](* args)
    nil
  end

  def length
    nil
  end
end

class Hash
  def except(*keys)
    dup.except!(*keys)
  end
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
  def map_values!(&block)
    keys.each do |key|
      value = self[key]
      self[key] = yield(value)
    end
    self
  end

  def map_values(&block)
    dup.map_values!(&block)
  end
end

class String

  def is_json?(json)
    JSON.parse(json)
    true
  rescue
    false
  end

  def is_number?
    true if Float(self) rescue false
  end

  def to_singleline
    self.gsub(/\n+\s*/m, ' ')
  end

  def to_class
    Kernel.const_get self
  rescue NameError
    nil
  end

  def is_a_defined_class?
    true if self.to_class
  rescue NameError
    false
  end

  def first(n)
    till = n - 1
    self[0..till]
  end

  def last(n)
    self[-n, n]
  end

  def titleize
    split(/(\W)/).map(&:capitalize).join
  end

  def underscore
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase
  end

end

class BigDecimal
  old_to_s = instance_method :to_s
  define_method :to_s do |param='F'|
    old_to_s.bind(self).(param)
  end
end

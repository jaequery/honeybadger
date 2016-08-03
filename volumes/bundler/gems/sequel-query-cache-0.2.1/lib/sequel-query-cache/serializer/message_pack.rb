# coding: utf-8
require 'msgpack'

module Sequel::Plugins
  module QueryCache
    module Serializer
      module MessagePack
        def self.serialize(obj)
          obj.to_msgpack
        end

        def self.deserialize(string)
          ::MessagePack.unpack(string)
        end
      end
    end
  end
end

# Adds #to_msgpack to some common classes for packing purposes.
[BigDecimal, Bignum, Date, Time, Sequel::SQLTime].each do |klass|
  unless klass.instance_methods.include? :to_msgpack
    klass.send(:define_method, :to_msgpack) {|io=nil| to_s.to_msgpack(io)}
  end
end

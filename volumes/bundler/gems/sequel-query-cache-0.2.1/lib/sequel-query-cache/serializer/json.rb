# coding: utf-8
require 'json'

module Sequel::Plugins
  module QueryCache
    module Serializer
      # While this works, if you're using binary data at all, it's not a great
      # idea and MessagePack is faster.
      module JSON
        def self.serialize(obj)
          binding.pry
          obj.to_json
        end

        # Keys are specifically *NOT* symbolized here. This is done by
        # Sequel::Plugins::Cacheable::DatasetMethods#fetch_rows since only the
        # top level needs to have symbolized keys for Sequel's purposes.
        def self.deserialize(string)
          ::JSON.parse(string)
        end
      end
    end
  end
end

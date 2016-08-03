# coding: utf-8
require 'sequel'
require 'sequel-query-cache/version'
require 'sequel-query-cache/driver'
require 'sequel-query-cache/class_methods'
require 'sequel-query-cache/instance_methods'
require 'sequel-query-cache/dataset_methods'

module Sequel::Plugins
  module QueryCache
    def self.configure(model, store, opts={})
      model.instance_eval do
        @cache_options = {
          :ttl => 3600,
          :cache_by_default => {
            :always => false,
            :if_limit => 1
          }
        }.merge(opts)

        @cache_driver = Driver.from_store(
          store,
          :serializer => @cache_options.delete(:serializer)
        )
      end
    end
  end
end

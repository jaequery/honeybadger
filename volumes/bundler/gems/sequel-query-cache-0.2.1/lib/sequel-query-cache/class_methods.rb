# coding: utf-8
module Sequel::Plugins
  module QueryCache
    module ClassMethods
      attr_reader :cache_driver, :cache_options

      def cached(opts={})
        dataset.cached(opts)
      end

      def not_cached
        dataset.not_cached
      end

      def default_cached
        dataset.default_cached
      end
    end
  end
end

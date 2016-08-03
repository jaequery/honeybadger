# coding: utf-8
module Sequel
  module Plugins
    module QueryCache
      MAJOR_VERSION = 0
      MINOR_VERSION = 2
      TINY_VERSION  = 1
      VERSION = [MAJOR_VERSION, MINOR_VERSION, TINY_VERSION].join('.')

      def self.version; VERSION; end
    end
  end
end

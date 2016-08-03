# coding: utf-8
module Sequel::Plugins
  module QueryCache
    class MemcacheDriver < Driver
      def del(key)
        store.delete(key)
      end

      def expire(key, time)
        store.set(key, store.get(key), time)
      end
    end
  end
end

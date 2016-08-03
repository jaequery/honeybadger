# coding: utf-8
module Sequel::Plugins
  module QueryCache
    class DalliDriver < Driver
      def del(key)
        store.delete(key)
      end

      def expire(key, time)
        if time > 0
          store.touch(key, time)
        else
          store.delete(key)
        end
      end
    end
  end
end

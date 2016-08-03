# coding: utf-8
module Sequel::Plugins
  module QueryCache
    module InstanceMethods
      # For the purpose of caching, it's helpful to have the dataset that
      # is actually responsible for creating the model instance since it's
      # likely that if the instance is updated you'll want the dataset related
      # to it to be cleaned up. See #recache_source_dataset! for further
      # information.
      attr_accessor :source_dataset

      def before_save
        # Since the cache will be updated after the save is complete there's no
        # reason to have it deleted by the update process.
        this.cache_clear_on_update = false
        super
      end

      def after_save
        super
        recache_source_dataset!
        cache!
      end

      def cache_key
        this.cache_key
      end

      def cache!(opts={})
        this.cache_set([self], opts) if this.is_cacheable?
        self
      end

      def uncache!
        this.cache_del if this.is_cacheable?
        source_dataset.cache_del if source_dataset_cache?
        self
      end

      def to_msgpack(io=nil)
        values.to_msgpack(io)
      end

      private
      # There are many instances where the dataset that creates a model instance
      # is not equal to #this. The two most common instances are when a model
      # has a unique column that is used on a regular basis to fetch records
      # (e.g. an email address in a User model) or a foreign key.
      #
      # In the event that the source dataset is guaranteed to return only one
      # result (has a limit statement of 1) it will be cached. If it is not, the
      # related cached will be cleared in an attempt to clean up potentially
      # stale queries.
      def recache_source_dataset!
        if source_dataset_cache?
          if source_dataset.opts[:limit] == 1
            source_dataset.cache_set([self])
          else
            source_dataset.cache_del
          end
        end
      end

      def source_dataset_cache?
        source_dataset &&
          (source_dataset != this) &&
          source_dataset.respond_to?(:is_cacheable?) &&
          source_dataset.is_cacheable?
      end
    end
  end
end

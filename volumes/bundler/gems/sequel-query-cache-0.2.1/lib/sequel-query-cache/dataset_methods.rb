# coding: utf-8
require 'digest/md5'

module Sequel::Plugins
  module QueryCache
    module DatasetMethods
      CACHE_BY_DEFAULT_PROC = lambda do |ds, opts|
        if ds.opts[:limit] && opts[:if_limit]
          return true if
            (opts[:if_limit] == true) ||
            (opts[:if_limit] >= ds.opts[:limit])
        end

        false
      end

      # Returns the model's cache driver.
      #--
      # TODO: Caching should be modified to be a database/dataset extension with
      # a tiny plugin for the models. However, this works just fine for now.
      #++
      def cache_driver
        model.cache_driver
      end

      # Copies the model's +cache_options+ and merges them with options provided
      # by +opts+ if any are provided. Returns the current cache_options.
      #
      # <tt>@cache_options</tt> is cloned when the dataset is cloned.
      def cache_options(opts=nil)
        @cache_options ||= model.cache_options
        @cache_options = @cache_options.merge(opts) if opts
        @cache_options
      end

      # Determines whether or not to cache a dataset based on the configuration
      # settings of the plugin.
      #--
      # TODO: Specify a place to find those settings. However, where those are
      # applied is currently in flux. Also, further document how this process
      # actually works.
      #++
      def is_cacheable_by_default?
        cache_by_default = cache_options[:cache_by_default]
        return false unless cache_by_default
        return true if cache_by_default[:always]
        proc = cache_by_default[:proc] || CACHE_BY_DEFAULT_PROC
        proc.call(self, cache_by_default)
      end

      # Determines whether or not a dataset should be cached. If
      # <tt>@is_cacheable</tt> is set that value will be returned, otherwise the
      # default value will be returned by #is_cacheable_by_default?
      def is_cacheable?
        defined?(@is_cacheable) ? @is_cacheable : is_cacheable_by_default?
      end

      # Sets the value for <tt>@is_cacheable</tt> which is used as the return
      # value from #is_cacheable?. <tt>@is_cacheable</tt> is cloned when the
      # dataset is cloned.
      #
      # *Note:* In general, #cached and #not_cached should be used to set this
      # value. This method exists primarily for their use.
      def is_cacheable=(is_cacheable)
        @is_cacheable = !!is_cacheable
      end

      # Clones the current dataset, sets it to be cached and returns the new
      # dataset. This is useful for chaining purposes:
      #
      #   dataset.where(column1: true).order(:column2).cached.all
      #
      # In the above example, the data would always be pulled from the cache or
      # cached if it wasn't already. The value of <tt>@is_cacheable</tt> is
      # cloned when a dataset is cloned, so the following example would also
      # have the same result:
      #
      #   dataset.cached.where(column1: true).order(:column2).all
      #
      # +opts+ is passed to #cache_options on the new dataset.
      def cached(opts=nil)
        c = clone
        c.cache_options(opts)
        c.is_cacheable = true
        c
      end

      # Clones the current dataset, sets it to not be cached and returns the new
      # dataset. See #cached for further details and examples.
      def not_cached
        c = clone
        c.is_cacheable = false
        c
      end

      # Clones the current dataset, returns the caching state to whatever
      # would be default for that dataset and returns the new dataset. See
      # #cached for further details and examples.
      #
      # *Note:* This is the "proper" way to clear <tt>@is_cacheable</tt> once
      # it's been set.
      def default_cached
        if defined? @is_cacheable
          c = clone
          c.remove_instance_variable(:@is_cacheable)
          c
        else
          self
        end
      end

      # Creates a default cache key, which is an MD5 base64 digest of the
      # the literal select SQL with +Sequel:+ added as a prefix. This value is
      # memoized because assembling the SQL string and hashing it every time
      # this method gets called is obnoxious.
      def default_cache_key
        @default_cache_key ||= "Sequel:#{Digest::MD5.base64digest(sql)}"
      end

      # Returns the default cache key if a manual cache key has not been set.
      # The cache key is used by the storage engines to retrieve cached data.
      # The default will suffice in almost all instances.
      def cache_key
        @cache_key || default_cache_key
      end

      # Sets a manual cache key for a dataset that overrides the default MD5
      # hash. This key has no +Sequel:+ prefix, so if that's important, remember
      # to add it manually.
      #
      # *Note:* Setting the cache key manually is *NOT* inherited by cloned
      # datasets since keys are presumed to be for the current dataset and any
      # changes, such as where clauses or limits, should result in a new key. In
      # general, you shouldn't change the cache key unless you have a really
      # good reason for doing so.
      def cache_key=(cache_key)
        @cache_key = cache_key ? cache_key.to_s : nil
      end

      def clear_cache_keys!
        remove_instance_variable(:@default_cache_key) if defined? @default_cache_key
        remove_instance_variable(:@cache_key) if defined? @cache_key
      end

      # Gets the cache value using the current dataset's key and logs the
      # action. The underlying driver should return +nil+ in the event that
      # there is no cached data. Also logs whether there was a hit or miss on
      # the cache.
      def cache_get
        db.log_info("CACHE GET: #{cache_key}")
        cached_rows = cache_driver.get(cache_key)
        db.log_info("CACHE #{cached_rows ? 'HIT' : 'MISS'}: #{cache_key}")
        cached_rows
      end

      # Sets the cache value using the current dataset's key and logs the
      # action. In general, this method should not be called directly. It's
      # exposed because model instances need access to it.
      #
      # An +opts+ hash can be passed to override any default options being sent
      # to the driver. The most common use for this would be to modify the +ttl+
      # for a cache. However, this should probably be done using #cached rather
      # than doing anything directly via this method.
      def cache_set(value, opts={})
        db.log_info("CACHE SET: #{cache_key}")
        cache_driver.set(cache_key, value, opts.merge(cache_options))
      end

      # Deletes the cache value using the current dataset's key and logs the
      # action.
      def cache_del
        db.log_info("CACHE DEL: #{cache_key}")
        cache_driver.del(cache_key)
      end

      def cache_clear_on_update
        @cache_clear_on_update.nil? ? true : @cache_clear_on_update
      end

      def cache_clear_on_update=(v)
        @cache_clear_on_update = !!v
      end

      # Overrides the dataset's existing +update+ method. Deletes an existing
      # cache after a successful update.
      def update(values={}, &block)
        result = super
        cache_del if is_cacheable? && cache_clear_on_update
        result
      end

      # Overrides the dataset's existing +delete+ method. Deletes an existing
      # cache after a successful delete.
      def delete(&block)
        result = super
        cache_del if is_cacheable?
        result
      end

      # Overrides the dataset's existing +fetch_rows+ method. If the dataset is
      # cacheable it will do one of two things:
      #
      # If a cache exists it will yield the cached rows rather query the
      # database.
      #
      # If a cache does not exist it will query the database, store the results
      # in an array, cache those and then yield the results like the original
      # method would have.
      #
      # *Note:* If you're using PostgreSQL, or another database where +each+
      # iterates with the cursor rather over the dataset results, you'll lose
      # that functionality when caching is enabled for a query since the entire
      # result is iterated first before it is yielded. If that behavior is
      # important, remember to disable caching for that particular query.
      def fetch_rows(sql)
        if is_cacheable?
          if cached_rows = cache_get
            # Symbolize the row keys before yielding as they're often strings
            # when the data is deserialized. Sequel doesn't play nice with
            # string keys.
            cached_rows.each{|r| yield r.reduce({}){|h,v| h[v[0].to_sym]=v[1]; h}}
          else
            cached_rows = []
            super(sql){|r| cached_rows << r}
            cache_set(cached_rows)
            cached_rows.each{|r| yield r}
          end
        else
          super
        end
      end

      # Sets self as the source_dataset on a result if that result supports
      # source datasets. While it can almost certainly be presumed the result
      # will, if the dataset's row_proc has been modified for some reason the
      # result might be different than expected.
      def each
        super do |r|
          r.source_dataset = self if r.respond_to? :source_dataset=
          yield r
        end
      end

      # Overrides the dataset's existing clone method. Clones the existing
      # dataset but clears any manually set cache key and the memoized default
      # cache key to ensure it's regenerated by the new dataset.
      def clone(opts=nil)
        c = super(opts)
        c.clear_cache_keys!
        c
      end
    end
  end
end

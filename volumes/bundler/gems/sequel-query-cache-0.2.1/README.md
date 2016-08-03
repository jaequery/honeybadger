Sequel Query Cache
==================

Sequel Query Cache is a Sequel model plugin that allows the results of Sequel datasets to be cached in a key-value store like Memcached or Redis. This plugin is flexible and can easily be adapted to other key-value stores.

Results are serialized for storage by default using JSON or [MessagePack](http://msgpack.org/) if the [MessagePack gem](https://github.com/msgpack/msgpack-ruby) is available. This is also flexible. Any object with a very simple interface can be used to serialize and unserialize data.

Sequel Query Cache was forked from Sho Kusano's [sequel-cacheable gem](https://github.com/rosylilly/sequel-cacheable) and while it has seen substantial internal architectural changes, it maintains the original spirit of being easy to adapt to multiple cache stores and serialization options.

Installation
------------

Sequel Query Cache requires [Sequel](https://github.com/jeremyevans/sequel) and one of the following gems for accessing cache store:

* [Redis](https://rubygems.org/gems/redis)
* [Hiredis](https://rubygems.org/gems/hiredis)
* [Memcached](https://rubygems.org/gems/memcache)
* [Dalli](https://rubygems.org/gems/dalli)

Additionally, using [MessagePack](https://github.com/msgpack/msgpack-ruby) is strongly encouraged over the JSON default and is necessary when caching binary data.

Configuration
-------------

First, initialize a cache client.

Using Dalli:

```ruby
CACHE_CLIENT = Dalli::Client.new('localhost:11211')
```

Using Redis:

```ruby
CACHE_CLIENT = Redis.new(host: 'localhost', port: 6379)
```

Then, apply the plugin to all models:

```ruby
Sequel::Model.plugin :query_cache, CACHE_CLIENT
```

Or just a select few:

```ruby
MyModel.plugin :query_cache, CACHE_CLIENT
```

Configuration Options
---------------------

The plugin method also accepts a hash of options as a final argument, like so:

```ruby
Sequel::Model.plugin :query_cache, CACHE_CLIENT, ttl: 3600
```

The current options are:

* **ttl**: Time to live. The amount of time before a given cache expires automatically.
* **serializer**: An object that responds to serialize and unserialize methods for converting Sequel result hashs and models to serialized strings.
* **cache_by_default**: See below.

Cached Datasets
---------------

When a dataset is set to have its results cached, if a method that would return results is called (e.g. #first or #all) a check will be made to see if there are any cached results. If there are, the cached results will be used. If there are not, the results will be pulled from the database, cached in the store and then passed to the user.

Whether or not dataset results are cached is determined in one of two ways. The first is to explicitly set a dataset to be cached. For example:

```ruby
MyModel.cached.all
```

This will check the cache for results and set them if they do not exist. Caching be be explicitly ignored as well:

```ruby
MyModel.uncached.all
```

The second way a determination to cache a dataset is made is by the options set by cache_by_default. By default, these are set to cache the results of any query which has a LIMIT clause set to 1.

For more details on how cache_by_default, see the documentation for Sequel::Plugins::QueryCache and Sequel::Plugins::QueryCache::DatasetMethods.

Caches are automatically deleted when a dataset is updated or deleted.

Cached Models
---------------

Models have a few additional features on top of their respective dataset. Models can have their caches explicitly set or deleted by calling #cache! or #uncache! on a model instance.

Additionally, models have an #after_save hook that updates caches associated with model instances.

TODO
----

* The testing suite is completely broken and needs to be updated.
* Additional documentation and commenting needs to be added to the source, particularly for the functionality of cache_by_default.
* There is basically no need for this plugin to require the use of models and could be used purely as a dataset extension with a tiny model plugin built on top. This should be implemented at some point.

Thanks
------

* [Sho Kusano](https://github.com/rosylilly)
* [Jeremy Watkins](https://github.com/vegasje)

Copyright
---------

Copyright (c) 2013 Joshua Hansen. See LICENSE for further details.

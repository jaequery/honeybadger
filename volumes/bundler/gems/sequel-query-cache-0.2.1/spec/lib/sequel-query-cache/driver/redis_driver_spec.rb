require 'spec_helper'

describe Sequel::Plugins::QueryCache::RedisDriver do
  let(:store) { RedisCli }

  include_examples :driver
end


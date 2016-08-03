require 'spec_helper'

describe Sequel::Plugins::QueryCache::MemcacheDriver do
  let(:store) { MemcacheCli }

  include_examples :driver
end

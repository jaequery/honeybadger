require 'spec_helper'

describe Sequel::Plugins::QueryCache::Driver do
  let(:store) { RedisCli }

  include_examples :driver

  describe '.factory' do
    subject { described_class.factory(store) }

    context 'when Memcache' do
      let(:store) { MemcacheCli }

      it { should be_a(Sequel::Plugins::QueryCache::MemcacheDriver) }
    end

    context 'when Dalli' do
      let(:store) { DalliCli }

      it { should be_a(Sequel::Plugins::QueryCache::DalliDriver) }
    end

    context 'when Redis' do
      let(:store) { RedisCli }

      it { should be_a(Sequel::Plugins::QueryCache::RedisDriver) }
    end

    context 'when Unkown Store' do
      let(:store) { mock }

      it { should be_a(Sequel::Plugins::QueryCache::Driver) }
    end
  end
end

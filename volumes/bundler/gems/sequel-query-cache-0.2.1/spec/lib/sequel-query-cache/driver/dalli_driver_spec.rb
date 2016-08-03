require 'spec_helper'

describe Sequel::Plugins::QueryCache::DalliDriver do
  let(:store) { DalliCli }

  include_examples :driver
end


# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  require 'will_paginate'
  require 'will_paginate/sequel'
  require 'will_paginate/view_helpers/sinatra'
  include WillPaginate::Sinatra::Helpers
  require "bootstrap_pagination/sinatra"
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

# Setup better_errors
if Padrino.env == :development
  require 'better_errors'
  Padrino::Application.use BetterErrors::Middleware
  BetterErrors.application_root = PADRINO_ROOT
  BetterErrors.logger = Padrino.logger
  BetterErrors::Middleware.allow_ip! '172.0.0.0/0'
end

Padrino.load!

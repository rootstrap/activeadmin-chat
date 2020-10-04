ENV['RAILS_ENV'] ||= 'test'
ENV['RACK_ENV'] ||= ENV['RAILS_ENV']
ENV['NODE_ENV'] ||= ENV['RAILS_ENV']

require 'bundler/setup'

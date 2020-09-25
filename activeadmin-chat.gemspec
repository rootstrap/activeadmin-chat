# frozen_string_literal: true

require_relative 'lib/active_admin/chat/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'activeadmin-chat'
  s.version     = ActiveAdmin::Chat::VERSION
  s.authors     = ['Santiago Bartesaghi', 'Federico Aldunate']
  s.email       = ['santiago.bartesaghi@rootstrap.com', 'federico@rootstrap.com']
  s.homepage    = 'https://github.com/rootstrap/activeadmin-chat'
  s.summary     = 'ActiveAdmin chat plugin'
  s.description = s.summary
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'activeadmin', '>= 2.0'
  s.add_dependency 'rails', '>= 5.2'
  s.add_dependency 'webpacker', '>= 5.0'

  s.add_development_dependency 'action-cable-testing', '>= 0.4.0'
  s.add_development_dependency 'byebug', '~> 10.0.0'
  s.add_development_dependency 'capybara', '~> 3.32.2'
  s.add_development_dependency 'factory_bot_rails', '~> 4.11.1'
  s.add_development_dependency 'generator_spec', '~> 0.9.4'
  s.add_development_dependency 'puma', '~> 4.3.3'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.59.2'
  s.add_development_dependency 'selenium-webdriver', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
  s.add_development_dependency 'sqlite3', '>= 1.3.0'
end

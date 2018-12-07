$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'active_admin_chat/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'active_admin_chat'
  s.version     = ActiveAdminChat::VERSION
  s.authors     = ['Santiago Bartesaghi']
  s.email       = ['santiago.bartesaghi@rootstrap.com']
  s.homepage    = 'https://github.com/rootstrap/active_admin_chat'
  s.summary     = 'ActiveAdmin chat plugin'
  s.description = s.summary
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'activeadmin', '>= 1.0.0'
  s.add_dependency 'rails', '>= 5.0.0'

  s.add_development_dependency 'action-cable-testing'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.59.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'
end

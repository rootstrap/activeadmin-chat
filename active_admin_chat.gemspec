$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "active_admin_chat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_admin_chat"
  s.version     = ActiveAdminChat::VERSION
  s.authors     = ["Santiago Bartesaghi"]
  s.email       = ["santiago.bartesaghi@rootstrap.com"]
  s.homepage    = "https://github.com/rootstrap/active_admin_chat"
  s.summary     = "ActiveAdmin chat plugin"
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"
  s.add_dependency "activeadmin", "~> 1.3.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.8"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_bot_rails"
end

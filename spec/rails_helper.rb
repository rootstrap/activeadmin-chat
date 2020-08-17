# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'action_cable/testing/rspec'
require 'selenium/webdriver'
require 'simplecov'
require 'factory_bot_rails'

SimpleCov.start

# Setup ActiveAdmin
ActiveAdmin.application.load_paths = [File.expand_path('dummy/app/admin', __dir__)]
ActiveAdmin.unload!
ActiveAdmin.load!
Rails.application.reload_routes!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu'])

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :headless_chrome

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:each, type: :feature) do
    # Ensure that the client JavaScript within the app is synced with the gem
    DummyAppHelpers.link_client!
  end

  # To avoid running every test twice on subsequent runs because of the
  # recursive symlink, make sure to unlink the client.
  config.after(:suite) do
    DummyAppHelpers.unlink_client!
  end

  FactoryBot.definition_file_paths << File.expand_path('dummy/factories', __dir__)
  config.before do
    FactoryBot.reload
  end
end

class DummyAppHelpers
  class << self
    def link_client!
      return if @linked

      yarn! '--cwd', '../../..', 'link'
      yarn! 'link', 'activeadmin-chat'
      yarn! 'install'

      clear_webpacker_cache!

      @linked = true
    end

    def unlink_client!
      return unless @linked

      yarn! 'unlink', 'activeadmin-chat'
    end

    private

    def clear_webpacker_cache!
      webpacker_cache_path = File.expand_path('tmp/cache', Rails.root)
      FileUtils.rm_r(webpacker_cache_path) if File.exist?(webpacker_cache_path)
    end

    def yarn!(*args)
      stdout, stderr, status =
        Open3.capture3('bin/yarn', *args, chdir: Rails.root)

      return if status.success?

      short_output = [stdout, stderr].delete_if(&:empty?).join("\n\n")
      raise "Failed to `yarn #{args.join(' ')}`! Yarn says:\n#{short_output}"
    end
  end
end

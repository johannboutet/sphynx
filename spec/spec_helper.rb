require 'simplecov'
SimpleCov.start('test_frameworks') do
  minimum_coverage 80
end

require 'bundler/setup'
require 'sphynx'

Dir[File.dirname(__FILE__) + '/fixtures/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

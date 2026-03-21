# frozen_string_literal: true

require 'bundler/setup'

module Legion
  module Extensions
    module Core; end
  end
end

require 'legion/extensions/google_calendar'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

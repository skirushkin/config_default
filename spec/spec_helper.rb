# frozen_string_literal: true

require "pry"
require "rails"

require "config_default"

ConfigDefault.configure do |config|
  config.config_path = "./spec/config_examples"
  config.postfix = "default"
end

Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |f| require(f) }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.disable_monkey_patching!
  config.expose_dsl_globally = true

  config.order = :random
  Kernel.srand config.seed
end

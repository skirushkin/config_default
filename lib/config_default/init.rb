# frozen_string_literal: true

module ConfigDefault::Init
  extend self

  def init_rails_monkey_patch!
    return unless Object.const_defined?(:Rails)
    return unless Object.const_defined?(:"Rails::Application")
    return unless Object.const_defined?(:"Rails::Application::Configuration")

    Rails::Application.prepend(ConfigDefault::RailsApplicationExtension)
    Rails::Application::Configuration.prepend(ConfigDefault::RailsApplicationConfigurationExtension)
  end
end

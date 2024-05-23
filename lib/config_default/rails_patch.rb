# frozen_string_literal: true

module ConfigDefault::RailsApplicationConfigurationPatch
  def load_database_yaml
    ConfigDefault.load(:database, key: nil)
  end

  def database_configuration
    load_database_yaml
  end
end

module ConfigDefault::RailsApplicationPatch
  def config_for(name, env: Rails.env)
    data = ConfigDefault.load(name, key: env, deep_symbolize_keys: true)
    ActiveSupport::OrderedOptions.new.merge(data)
  end
end

module ConfigDefault::RailsPatch
  extend self

  def apply!
    return unless Object.const_defined?(:Rails)

    Rails::Application.prepend(ConfigDefault::RailsApplicationPatch)
    Rails::Application::Configuration.prepend(ConfigDefault::RailsApplicationConfigurationPatch)
  end
end

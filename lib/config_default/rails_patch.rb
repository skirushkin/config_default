# frozen_string_literal: true

# NOTE: Patch for #config_for method to support configuration. Used by rabbit_messaging gem
# https://github.com/rails/rails/blob/main/railties/lib/rails/application.rb#L295
module ConfigDefault::RailsApplicationConfigurationPatch
  def load_database_yaml
    ConfigDefault.hash(:database, key: nil)
  end

  def database_configuration
    load_database_yaml
  end
end

# NOTE: Patch Rails to load database configuration
# https://github.com/rails/rails/blob/main/railties/lib/rails/application/configuration.rb#L467
module ConfigDefault::RailsApplicationPatch
  def config_for(name, env: Rails.env)
    data = ConfigDefault.hash(name, key: env, deep_symbolize_keys: true)
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

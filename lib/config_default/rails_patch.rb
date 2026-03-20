# frozen_string_literal: true

# NOTE: Patch Rails::Application to add support in #config_for method
# https://github.com/rails/rails/blob/main/railties/lib/rails/application.rb#L295
module ConfigDefault::RailsApplicationPatch
  def config_for(name, env: Rails.env)
    data = ConfigDefault.hash(name, key: env, deep_symbolize_keys: true)
    ActiveSupport::OrderedOptions.new.merge(data)
  end
end

# NOTE: Patch Rails::Application::Configuration to add support into database conf files
# https://github.com/rails/rails/blob/main/railties/lib/rails/application/configuration.rb#L467
module ConfigDefault::RailsApplicationConfigurationPatch
  def load_database_yaml
    ConfigDefault.hash(:database, key: nil)
  end

  def database_configuration
    load_database_yaml
  end
end

# frozen_string_literal: true

module Rails::Application::ConfigurationExtension
  def load_database_yaml
    ConfigDefault.load(:database, key: nil)
  end

  def database_configuration
    load_database_yaml
  end
end

Rails::Application::Configuration.prepend(Rails::Application::ConfigurationExtension)

# frozen_string_literal: true

module ConfigDefault::RailsApplicationConfigurationExtension
  def load_database_yaml
    ConfigDefault.load(:database, key: nil)
  end

  def database_configuration
    load_database_yaml
  end
end

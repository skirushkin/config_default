# frozen_string_literal: true

require "config_default/version"
require "config_default/struct"

require "config_default/rails/application/configuration_extension"
require "config_default/rails/application_extension"

module ConfigDefault
  extend self

  def load(name, key: Rails.env)
    base_config = load_file("#{name}.default")
    config = load_file(name)

    data = base_config.deep_merge(config)
    data = key ? data[key] : data

    data.symbolize_keys
  end

  def load_file(name)
    ActiveSupport::ConfigurationFile.parse(Rails.root.join("config/#{name}.yml"))
  rescue
    {}
  end

  def load_struct(name, key: Rails.env)
    ConfigDefault::Struct.new(load(name, key: key))
  end
end

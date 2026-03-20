# frozen_string_literal: true

require "active_support/core_ext/hash"

require "config_default/version"
require "config_default/config"
require "config_default/rails_patch"
require "config_default/struct"

module ConfigDefault
  extend self

  attr_accessor :config

  @config = ConfigDefault::Config.new

  def configure
    yield(config) if block_given?
  end

  def apply_rails_patch!
    return unless Object.const_defined?(:Rails)

    Rails::Application.prepend(ConfigDefault::RailsApplicationPatch)
    Rails::Application::Configuration.prepend(ConfigDefault::RailsApplicationConfigurationPatch)
  end

  def hash(name, key: Rails.env, symbolize_keys: false, deep_symbolize_keys: false)
    default_config = read_file("#{name}.#{config.postfix}")
    config = read_file(name)

    if key
      default_config = default_config[key] || {}
      config = config[key] || {}
    end

    data = default_config.deep_merge(config)

    if deep_symbolize_keys
      data.deep_symbolize_keys
    elsif symbolize_keys
      data.symbolize_keys
    else
      data
    end
  end

  def struct(name, key: Rails.env, recursive: false, allow_nil: false, &block)
    attributes = hash(name, key: key)
    struct = ConfigDefault::Struct.new(attributes, recursive: recursive, allow_nil: allow_nil)
    struct.class_eval(&block) if block
    struct
  end

  private

  def read_file(name)
    file_name = File.join(config.config_path, "#{name}.yml")
    ActiveSupport::ConfigurationFile.parse(file_name)
  rescue
    {}
  end
end

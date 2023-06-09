# frozen_string_literal: true

require "active_support/core_ext/hash"

require "config_default/version"
require "config_default/config"
require "config_default/init"
require "config_default/struct"
require "config_default/rails_application_extension"
require "config_default/rails_application_configuration_extension"

module ConfigDefault
  extend self

  attr_accessor :config

  @config = ConfigDefault::Config.new

  def configure
    yield(config) if block_given?
  end

  def init_rails_monkey_patch!
    ConfigDefault::Init.init_rails_monkey_patch!
  end

  def load(name, key: Rails.env, symbolize_keys: false, deep_symbolize_keys: false)
    default_config = load_file("#{name}.#{config.postfix}")
    config = load_file(name)

    data = default_config.deep_merge(config)
    data = key ? data[key] : data

    return {} if data.nil?

    if deep_symbolize_keys
      data.deep_symbolize_keys
    elsif symbolize_keys
      data.symbolize_keys
    else
      data
    end
  end

  def load_file(name)
    file_name = File.join(config.config_path, "#{name}.yml")
    ActiveSupport::ConfigurationFile.parse(file_name)
  rescue
    {}
  end

  def load_struct(name, key: Rails.env, recursive: false, allow_nil: false)
    attributes = load(name, key: key)
    ConfigDefault::Struct.new(attributes, recursive: recursive, allow_nil: allow_nil)
  end
end

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
    path1 = File.join(config.config_path, "#{name}.#{config.postfix}.yml")
    path2 = File.join(config.config_path, "#{name}.yml")

    unless File.exist?(path1) || File.exist?(path2)
      raise Errno::ENOENT.new("#{path1} && #{path2}")
    end

    config1 = File.exist?(path1) ? ActiveSupport::ConfigurationFile.parse(path1) : {}
    config2 = File.exist?(path2) ? ActiveSupport::ConfigurationFile.parse(path2) : {}

    if key
      config1 = config1[key] || {}
      config2 = config2[key] || {}
    end

    data = config1.deep_merge(config2)

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
end

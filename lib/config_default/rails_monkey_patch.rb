# frozen_string_literal: true

module ConfigDefault::RailsMonkeyPatch
  extend self

  def call
    return unless Object.const_defined?("Rails")
    return unless Object.const_defined?("Rails::Application")
    return unless Object.const_defined?("Rails::Application::Configuration")

    require "config_default/rails/application_extension"
    require "config_default/rails/application/configuration_extension"
  end
end

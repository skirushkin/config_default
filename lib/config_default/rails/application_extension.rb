# frozen_string_literal: true

module Rails::ApplicationExtension
  def config_for(name, env: Rails.env)
    ActiveSupport::OrderedOptions.new.merge(ConfigDefault.load(name, key: env))
  end
end

Rails::Application.prepend(Rails::ApplicationExtension)

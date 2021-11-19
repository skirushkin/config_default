# frozen_string_literal: true

module Rails::ApplicationExtension
  def config_for(name, env: Rails.env)
    data = ConfigDefault.load(name, key: env, deep_symbolize_keys: true)
    ActiveSupport::OrderedOptions.new.merge(data)
  end
end

Rails::Application.prepend(Rails::ApplicationExtension)

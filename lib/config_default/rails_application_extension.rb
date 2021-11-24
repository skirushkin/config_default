# frozen_string_literal: true

module ConfigDefault::RailsApplicationExtension
  def config_for(name, env: Rails.env)
    data = ConfigDefault.load(name, key: env, deep_symbolize_keys: true)
    ActiveSupport::OrderedOptions.new.merge(data)
  end
end



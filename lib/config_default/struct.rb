# frozen_string_literal: true

class ConfigDefault::Struct
  def initialize(attributes = {})
    @attributes = ActiveSupport::HashWithIndifferentAccess.new(attributes).freeze
  end

  def [](key)
    @attributes[key]
  end

  def method_missing(method, *_args)
    @attributes[method] if @attributes.key?(method)
  end

  def respond_to_missing?(*_args)
    true
  end

  def to_hash
    @attributes
  end
end

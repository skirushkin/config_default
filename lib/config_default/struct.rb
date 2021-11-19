# frozen_string_literal: true

class ConfigDefault::Struct
  def initialize(attributes = {}, recursive: false, allow_nil: false)
    @attributes = ActiveSupport::HashWithIndifferentAccess.new(attributes)
    @allow_nil = allow_nil
    @recursive = recursive

    if @recursive
      @attributes.each do |key, value|
        next unless value.is_a?(Hash)
        @attributes[key] = self.class.new(value, recursive: @recursive, allow_nil: @allow_nil)
      end
    end

    @attributes.freeze
  end

  def [](key)
    @attributes[key]
  end

  def method_missing(method, *_args)
    return @attributes[method] if @attributes.key?(method)
    raise StandardError.new("There is no option :#{method} in configuration.") unless @allow_nil
  end

  def respond_to_missing?(*_args)
    true
  end

  def to_hash
    dup = @attributes.dup

    if @recursive
      dup.each do |key, value|
        next unless value.is_a?(self.class)
        dup[key] = value.to_hash
      end
    end

    dup
  end
end

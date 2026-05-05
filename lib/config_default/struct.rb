# frozen_string_literal: true

class ConfigDefault::Struct
  RESERVED_METHODS = %i[method_missing respond_to_missing? inspect to_hash to_s].freeze

  def initialize(attributes, recursive: false, allow_nil: false)
    @attributes = ActiveSupport::HashWithIndifferentAccess.new(attributes)
    @allow_nil = allow_nil
    @recursive = recursive

    make_recursive!
    define_methods!

    @attributes.freeze
  end

  def [](key)
    @attributes[key]
  end

  def method_missing(method, *_args)
    return if @allow_nil
    super
  end

  def inspect
    "#<ConfigDefault::Struct @attributes=#{to_hash} " \
      "@recursive=#{@recursive} @allow_nil=#{@allow_nil}>"
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

  private

  def make_recursive!
    return unless @recursive

    @attributes.each do |key, value|
      next unless value.is_a?(Hash)
      @attributes[key] = self.class.new(value, recursive: @recursive, allow_nil: @allow_nil)
    end
  end

  def define_methods!
    @attributes.each do |key, value|
      next if RESERVED_METHODS.include?(key.to_sym)

      value.freeze
      define_singleton_method(key) { value }
    end
  end
end

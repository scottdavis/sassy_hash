require 'sass'
class SassyHashException < Exception; end
class SassyHash < Hash
  VERSION = "0.0.1"

  def self.[](hash_values)
    super(hash_values).tap do |hash|
      hash.sassify!
    end
  end

  def initialize(*args)
    super(args).tap do |hash|
      hash.sassify!
    end
  end

  def sassify!
    keys.each do |key|
      new_key = self.class.sass_convert_value(key.to_s)
      self[new_key] = self.class.sass_convert_value(delete(key))
    end
  end


  def []=(key, value)
    key = self.class.sass_convert_value(key.to_s)
    value = self.class.sass_convert_value(value)
    super(key, value)
  end

  def self.sass_convert_value(value)
    case value
    when Integer, Float
      return ::Sass::Script::Value::Number.new(value)
    when Symbol
      return ::Sass::Script::Value::String.new(value.to_s)
    when String
      return ::Sass::Script::Value::String.new(value)
    when Array
      return ::Sass::Script::Value::List.new(value)
    when Hash
      return ::Sass::Script::Value::Map.new(self.class[value])
    when TrueClass, FalseClass
      return ::Sass::Script::Value::Bool.new(value)
    when ::Sass::Script::Value::Base
      return value
    else
      raise SassyHashException, "Non convertable value given" 
    end
  end

end

require 'sass'
class SassyHashException < Exception; end
class SassyHash < Hash
  VERSION = "0.0.2"
  VALID_UNIT = %r{(?<unit>#{::Sass::SCSS::RX::NMSTART}#{::Sass::SCSS::RX::NMCHAR}|%*)}
  VALID_NUMBER = %r{(?<number>#{::Sass::SCSS::RX::NUM})#{VALID_UNIT}}

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
      if matches = value.match(VALID_NUMBER)
        return ::Sass::Script::Value::Number.new(matches[:number], matches[:unit])
      end
      return ::Sass::Script::Value::String.new(value)
    when Array
      return ::Sass::Script::Value::List.new(array_to_list(value), :sapce)
    when Hash
      return ::Sass::Script::Value::Map.new(self[value])
    when TrueClass, FalseClass
      return ::Sass::Script::Value::Bool.new(value)
    when ::Sass::Script::Value::Base
      return value
    else
      raise SassyHashException, "Non convertable value given" 
    end
  end

  def self.array_to_list(array)
    array.map do |value|
      sass_convert_value(value)
    end
  end
end



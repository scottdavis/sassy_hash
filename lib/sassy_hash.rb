
require 'sass'
require 'sass/scss/rx'
class SassyHashException < Exception; end
class SassyHash < Hash
  VERSION       = "0.1.0"
  VALID_UNIT    = %r{(?<unit>#{::Sass::SCSS::RX::NMSTART}#{::Sass::SCSS::RX::NMCHAR}|%*)}
  FLOAT_OR_INT_MATCH  = %r{(?<float>^[0-9]*\.[0-9]+)|(?<int>^[0-9]+)}
  FLOAT_OR_INT = %r{(^[0-9]*\.[0-9]+|^[0-9]+)}
  VALID_NUMBER  = %r{(#{FLOAT_OR_INT_MATCH})#{VALID_UNIT}}
  RGB_REGEX     = %r{(rgba?\((?<colors>([^)]*))\))}

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

  def self.parse_color(value)
    sass_colors = Sass::Script::Value::Color::COLOR_NAMES
    if sass_colors.has_key?(value)
      return ::Sass::Script::Value::Color.new sass_colors[value]
    end
      # hex color
    if value =~ Sass::SCSS::RX::HEXCOLOR
      return ::Sass::Script::Value::Color.from_hex(value)
    end

    if matches = value.match(RGB_REGEX)
      colors = matches[:colors].split(',')
      colors.map!(&:to_f)
      return ::Sass::Script::Value::Color.new colors
    end

    nil
  end

  def self.sass_convert_value(value)
    case value
    when Integer, Fixnum
      return ::Sass::Script::Value::Number.new(value.to_i)
    when Float
      return ::Sass::Script::Value::Number.new(value.to_f)
    when Symbol
      return ::Sass::Script::Value::String.new(value.to_s)
    when String
      color = self.parse_color(value)
      return color unless color.nil?
      #number
      if matches = value.match(VALID_NUMBER)
        num = if matches[:float]
          matches[:float].to_f
        elsif matches[:int]
          matches[:int].to_i
        end
        return ::Sass::Script::Value::Number.new(num, matches[:unit])
      end
      #string
      return ::Sass::Script::Value::String.new(value)
    when Array
      return ::Sass::Script::Value::List.new(value.map {|v| sass_convert_value(v) }, :sapce)
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
end



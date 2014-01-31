require 'sass'
require 'sassy_hash'

describe SassyHash do

  def sass_value(str)
    SassyHash.sass_convert_value(str)
  end

  it "should create a sass string from hash value using []" do
    sassy_hash = SassyHash[:foo => :bar]
    sassy_hash[sass_value(:foo)].class.should eq(::Sass::Script::Value::String)
    sassy_hash[sass_value(:foo)].value.should eq('bar')
  end

  it "should create a sass string from hash value using []" do
    sassy_hash = SassyHash.new
    sassy_hash[:foo] = 'bar'
    sassy_hash[sass_value(:foo)].class.should eq(::Sass::Script::Value::String)
    sassy_hash[sass_value(:foo)].value.should eq('bar')
  end


  it "should create a sassy \"sub hash\"" do
    sassy_hash = SassyHash[:foo => {:bar => :baz}]
    sassy_hash[sass_value(:foo)].class.should eq(::Sass::Script::Value::Map)
    sassy_hash[sass_value(:foo)].value[sass_value(:bar)].should eq(sass_value(:baz))
  end

  it "should create a sass list from array" do
    array = [1,2]
    SassyHash.sass_convert_value(array).class.should eq(::Sass::Script::Value::List)
  end


  {
    'foo' => ::Sass::Script::Value::String,
    0 => ::Sass::Script::Value::Number,
    1.0 => ::Sass::Script::Value::Number,
    :foo => ::Sass::Script::Value::String,
    true => ::Sass::Script::Value::Bool,
    false => ::Sass::Script::Value::Bool
  }.each do |instance, klass|
    it "should return #{klass} from #{instance.inspect}" do
      SassyHash.sass_convert_value(instance).class.should eq(klass)
    end
  end
 

end

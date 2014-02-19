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

  it "should create a sass string from hash" do
    hash = {:foo => :bar}
    sassy_hash = SassyHash[hash]
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

  it "should create nested arrays" do
    array =[1,2,[3,4, [5,6]]]
    hash = {:foo => array}
    sassy_hash = SassyHash[hash]
    sassy_hash[sass_value(:foo)].value[2].class.should eq(::Sass::Script::Value::List)
  end

  it "should create nested arrays with maps" do
    array =[1,2,[3, 4, {:map => :foo}]]
    hash = {:foo => array}
    sassy_hash = SassyHash[hash]
    sassy_hash[sass_value(:foo)].value[2].class.should eq(::Sass::Script::Value::List)
    sassy_hash[sass_value(:foo)].value[2].value[2].class.should eq(::Sass::Script::Value::Map)
  end

  it "should create a hash valid for a map" do
    key = 'primaryColor'
    hash = {'height' => '120px', key => '#111', 'foo' => 'bar'}
    sassy_hash = SassyHash[hash]
    sassy_hash[sass_value(key)].class.should eq(::Sass::Script::Value::Color)
    sassy_hash[sass_value('height')].class.should eq(::Sass::Script::Value::Number)
    sassy_hash[sass_value('foo')].class.should eq(::Sass::Script::Value::String)
  end
  
  it "should create nested maps with string keys" do
    hash = {'foo' => {'bar' => {'baz' => 'hi'}}}
    sassy_hash = SassyHash[hash]
    sassy_hash[sass_value('foo')].value[sass_value('bar')].value[sass_value('baz')].value.should eq('hi')
  end

  it "should create a valid integer number" do
    hash = {:foo => "120px"}
    sassy_hash = SassyHash[hash]
    num = sassy_hash[sass_value(:foo)].value
    num.class.should eq(Fixnum)
    num.should eq(120)
  end

  it "should create a valid float number" do
    hash = {:foo => '120.5px'}
    sassy_hash = SassyHash[hash]
    num = sassy_hash[sass_value(:foo)].value
    num.class.should eq(Float)
    num.should eq(120.5)
  end

  {
    "#fff"    => ::Sass::Script::Value::Color,
    "#111"    => ::Sass::Script::Value::Color,
    "#eeeeee" => ::Sass::Script::Value::Color,
    'foo'     => ::Sass::Script::Value::String,
    0         => ::Sass::Script::Value::Number,
    1.0       => ::Sass::Script::Value::Number,
    "1.0px"   => ::Sass::Script::Value::Number,
    '1px'     => ::Sass::Script::Value::Number,
    '120px'   => ::Sass::Script::Value::Number,
    :foo      => ::Sass::Script::Value::String,
    true      => ::Sass::Script::Value::Bool,
    false     => ::Sass::Script::Value::Bool
  }.each do |instance, klass|
    it "should return #{klass} from #{instance.inspect}" do
      SassyHash.sass_convert_value(instance).class.should eq(klass)
    end
  end
 

end

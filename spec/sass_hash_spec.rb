require 'sass'
require 'sassy_hash'

describe SassyHash do

  def sass_value(str)
    SassyHash.sass_convert_value(str)
  end

  it "should create a sass string from hash value using []" do
    sassy_hash = SassyHash[:foo => :bar]
    sassy_hash[sass_value('foo')].class.should eq(::Sass::Script::Value::String)
    sassy_hash[sass_value('foo')].value.should eq('bar')
  end

  it "should create a sass string from hash value using []" do
    sassy_hash = SassyHash.new
    sassy_hash[:foo] = 'bar'
    sassy_hash[sass_value('foo')].class.should eq(::Sass::Script::Value::String)
    sassy_hash[sass_value('foo')].value.should eq('bar')
  end
 

end

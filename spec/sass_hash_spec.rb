require 'sassy_hash'

describe SassyHash do

  def sass_string(str)
    ::Sass::Script::Value::String.new(str)
  end

  it "should create a sass string from hash valuei using []" do
    sassy_hash = SassyHash[:foo => :bar]
    sassy_hash[sass_string('foo')].class.should eq(::Sass::Script::Value::String)
    sassy_hash[sass_string('foo')].value.should eq('bar')
  end

  #it "should create a sass string from hash valuei using []" do
    #sassy_hash = SassyHash.new
    #sassy_hash[:foo] = 'bar'
    #sassy_hash[sass_string('foo')].class.should eq(::Sass::Script::Value::String)
    #sassy_hash[sass_string('foo')].value.should eq('bar')
  #end
 

end

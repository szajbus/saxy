require 'spec_helper'

describe Saxy::Element do
  let(:element) { Saxy::Element.new }

  it "should not append empty string as value" do
    element.append_value("")
    element.value.should be_nil
  end

  it "should append stripped value" do
    element.append_value(" foo ")
    element.append_value(" bar ")
    element.value.should == "foobar"
  end

  it "should dump as string when no attributes are set" do
    element.stub(:value).and_return("foo")
    element.as_object.should == "foo"
  end

  it "should dump as object when attributes are set" do
    element.stub(:attributes).and_return("foo" => 1, "bar" => 2)
    object = element.as_object

    object.foo.should == 1
    object.bar.should == 2
  end

  it "should add attributes under underscored names" do
    element.set_attribute("FooBar", "baz")
    element.as_object.foo_bar.should == "baz"
  end
end
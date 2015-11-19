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
    element.to_h.should == "foo"
  end

  it "should dump as object when attributes are set" do
    element.stub(:attributes).and_return("foo" => 1, "bar" => 2)
    object = element.to_h

    object[:foo].should == 1
    object[:bar].should == 2
  end

  it "should dump as object with value when attributes and contents are set" do
    element.set_attribute("foo", "bar")
    element.append_value("value")
    object = element.to_h

    object[:foo].should == "bar"
    object[:contents].should == "value"
  end

  it "should add attributes under underscored names" do
    element.set_attribute("FooBar", "baz")
    element.to_h[:foo_bar].should == "baz"
  end

  it "should create array if adding multiple attributtes with the same name" do
    element.set_attribute("foo", "bar")
    element.set_attribute("foo", "baz")
    element.to_h[:foo].should == ["bar", "baz"]
  end
end

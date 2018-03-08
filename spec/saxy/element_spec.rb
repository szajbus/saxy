require 'spec_helper'

describe Saxy::Element do
  let(:element) { Saxy::Element.new }

  it "should not append empty string as value" do
    element.append_value("")
    expect(element.value).to be_nil
  end

  it "should append stripped value" do
    element.append_value(" foo ")
    element.append_value(" bar ")
    expect(element.value).to eq("foobar")
  end

  it "should preserve spacing around :&amp;" do
    element.append_value('&')
    expect(element.value).to eq(' & ')
  end

  it "should dump as string when no attributes are set" do
    expect(element).to receive(:value).and_return("foo")
    expect(element.to_h).to eq("foo")
  end

  it "should dump as object when attributes are set" do
    expect(element).to receive(:attributes).at_least(:once).and_return("foo" => 1, "bar" => 2)
    object = element.to_h

    expect(object[:foo]).to eq(1)
    expect(object[:bar]).to eq(2)
  end

  it "should dump as object with value when attributes and contents are set" do
    element.set_attribute("foo", "bar")
    element.append_value("value")
    object = element.to_h

    expect(object[:foo]).to eq("bar")
    expect(object[:contents]).to eq("value")
  end

  it "should add attributes under underscored names" do
    element.set_attribute("FooBar", "baz")
    expect(element.to_h[:foo_bar]).to eq("baz")
  end

  it "should create array if adding multiple attributtes with the same name" do
    element.set_attribute("foo", "bar")
    element.set_attribute("foo", "baz")
    expect(element.to_h[:foo]).to eq(["bar", "baz"])
  end
end

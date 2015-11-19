require 'spec_helper'

describe Saxy do
  include FixturesHelper

  it "should find object definitions in XML file and yield them as Ruby objects" do
    products = Saxy.parse(fixture_file("webstore.xml"), "product").inject([]) do |arr, product|
      arr << product
      arr
    end

    products[0][:uid].should == "FFCF177"
    products[0][:name].should == "Kindle"
    products[0][:description].should == "The world's best-selling e-reader."
    products[0][:price].should == "$109"
    products[0][:images][:thumb].should == "http://amazon.com/kindle_thumb.jpg"
    products[0][:images][:large].should == "http://amazon.com/kindle.jpg"

    products[1][:uid].should == "YD26NT"
    products[1][:name].should == "Kindle Touch"
    products[1][:description].should == "Simple-to-use touchscreen with built-in WIFI."
    products[1][:price].should == "$79"
    products[1][:images][:thumb].should == "http://amazon.com/kindle_touch_thumb.jpg"
    products[1][:images][:large].should == "http://amazon.com/kindle_touch.jpg"
  end

  it "should group multiple definitions of child objects into arrays" do
    webstore = Saxy.parse(fixture_file("webstore.xml"), "webstore").first

    webstore[:products][:product].should be_instance_of Array
    webstore[:products][:product].size.should == 2
  end

  it "should return Enumerator when calling #parse without a block", :unless => RUBY_1_8 do
    Saxy.parse(fixture_file("webstore.xml"), "product").each.should be_instance_of Enumerator
  end

  it "should return Enumerator when calling #parse without a block", :if => RUBY_1_8 do
    Saxy.parse(fixture_file("webstore.xml"), "product").each.should be_instance_of Enumerable::Enumerator
  end
end
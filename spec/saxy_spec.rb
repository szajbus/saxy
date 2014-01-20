require 'spec_helper'

describe Saxy do
  include FixturesHelper

  context "when it finds object definitions in XML file and yields a parsed object" do

    let(:products) {
        Saxy.parse(fixture_file("webstore.xml"), "product").inject([]) do |arr, product|
          arr << product
          arr
        end
    }

    let(:first_object) { products[0] }
    let(:second_object) { products[1] }

    it "should be acccessible by Object-style dot notation" do

      first_object.uid.should == "FFCF177"
      first_object.name.should == "Kindle"
      first_object.description.should == "The world's best-selling e-reader."
      first_object.price.should == "$109"
      first_object.images.thumb.should == "http://amazon.com/kindle_thumb.jpg"
      first_object.images.large.should == "http://amazon.com/kindle.jpg"

      second_object.uid.should == "YD26NT"
      second_object.name.should == "Kindle Touch"
      second_object.description.should == "Simple-to-use touchscreen with built-in WIFI."
      second_object.price.should == "$79"
      second_object.images.thumb.should == "http://amazon.com/kindle_touch_thumb.jpg"
      second_object.images.large.should == "http://amazon.com/kindle_touch.jpg"
    end

    context "when accessing the returned object with Hash-style bracket syntax" do

      it "should respond to strings as keys" do

        first_object["uid"].should == "FFCF177"
        first_object["name"].should == "Kindle"
        first_object["description"].should == "The world's best-selling e-reader."
        first_object["price"].should == "$109"
        first_object["images"].thumb.should == "http://amazon.com/kindle_thumb.jpg"
        first_object["images"].large.should == "http://amazon.com/kindle.jpg"

        second_object["uid"].should == "YD26NT"
        second_object["name"].should == "Kindle Touch"
        second_object["description"].should == "Simple-to-use touchscreen with built-in WIFI."
        second_object["price"].should == "$79"
        second_object["images"].thumb.should == "http://amazon.com/kindle_touch_thumb.jpg"
        second_object["images"].large.should == "http://amazon.com/kindle_touch.jpg"
      end

      it "should respond to symbols as keys" do

        first_object[:uid].should == "FFCF177"
        first_object[:name].should == "Kindle"
        first_object[:description].should == "The world's best-selling e-reader."
        first_object[:price].should == "$109"
        first_object[:images].thumb.should == "http://amazon.com/kindle_thumb.jpg"
        first_object[:images].large.should == "http://amazon.com/kindle.jpg"

        second_object[:uid].should == "YD26NT"
        second_object[:name].should == "Kindle Touch"
        second_object[:description].should == "Simple-to-use touchscreen with built-in WIFI."
        second_object[:price].should == "$79"
        second_object[:images].thumb.should == "http://amazon.com/kindle_touch_thumb.jpg"
        second_object[:images].large.should == "http://amazon.com/kindle_touch.jpg"
      end
    end
  end

  it "should group multiple definitions of child objects into arrays" do
    webstore = Saxy.parse(fixture_file("webstore.xml"), "webstore").first

    webstore.products.product.should be_instance_of Array
    webstore.products.product.size.should == 2
  end

  it "should return Enumerator when calling #parse without a block", :unless => RUBY_1_8 do
    Saxy.parse(fixture_file("webstore.xml"), "product").each.should be_instance_of Enumerator
  end

  it "should return Enumerator when calling #parse without a block", :if => RUBY_1_8 do
    Saxy.parse(fixture_file("webstore.xml"), "product").each.should be_instance_of Enumerable::Enumerator
  end
end
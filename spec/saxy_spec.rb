require 'spec_helper'

describe Saxy do
  include FixturesHelper

  it "should find object definitions in XML file and yield them as Ruby objects" do
    parser = Saxy::Parser.new(fixture_file("webstore.xml"), "product")

    products = parser.inject([]) do |arr, product|
      arr << product
      arr
    end

    products[0].uid.should == "FFCF177"
    products[0].name.should == "Kindle"
    products[0].description.should == "The world's best-selling e-reader."
    products[0].price.should == "$109"

    products[1].uid.should == "YD26NT"
    products[1].name.should == "Kindle Touch"
    products[1].description.should == "Simple-to-use touchscreen with built-in WIFI."
    products[1].price.should == "$79"
  end
end
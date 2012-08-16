require 'spec_helper'

describe Saxy::Parser do
  include FixturesHelper

  let(:parser) { Saxy::Parser.new(fixture_file("webstore.xml"), "product") }

  it "should push/pop tag names on/from stack when going down/up the XML tree" do
    parser.stack.should == %w( )

    parser.start_element('webstore')
    parser.stack.should == %w( webstore )

    parser.start_element('products')
    parser.stack.should == %w( webstore products )

    parser.start_element('product')
    parser.stack.should == %w( webstore products product )

    parser.end_element('product')
    parser.stack.should == %w( webstore products )

    parser.end_element('products')
    parser.stack.should == %w( webstore )

    parser.end_element('webstore')
    parser.stack.should == %w( )
  end

  it "should open object when detecting object tag opening" do
    parser.object.should be_nil
    parser.start_element("product")
    parser.object.should_not be_nil
  end

  it "should not open object when detecting other tag opening" do
    parser.object.should be_nil
    parser.start_element("other")
    parser.object.should be_nil
  end
end
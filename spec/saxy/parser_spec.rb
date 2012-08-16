require 'spec_helper'

describe Saxy::Parser do
  include FixturesHelper

  let(:parser) { Saxy::Parser.new(fixture_file("webstore.xml"), "product") }

  it "should have empty tag stack" do
    parser.tag_stack.should == %w( )
  end

  it "should push/pop tag names on/from tag stack when going down/up the XML tree" do
    parser.tag_stack.should == %w( )

    parser.start_element('webstore')
    parser.tag_stack.should == %w( webstore )

    parser.start_element('products')
    parser.tag_stack.should == %w( webstore products )

    parser.start_element('product')
    parser.tag_stack.should == %w( webstore products product )

    parser.end_element('product')
    parser.tag_stack.should == %w( webstore products )

    parser.end_element('products')
    parser.tag_stack.should == %w( webstore )

    parser.end_element('webstore')
    parser.tag_stack.should == %w( )
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

  context "with open object" do
    before do
      parser.start_element("product")
      parser.object.should_not be_nil
    end

    it "should close object when detecting object tag closing" do
      parser.end_element("product")
      parser.object.should be_nil
    end

    it "should not close object when detecting other tag closing" do
      parser.end_element("other")
      parser.object.should_not be_nil
    end
  end
end
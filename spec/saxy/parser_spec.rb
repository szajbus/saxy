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

  context "when detecting object tag opening" do
    before do
      parser.start_element("product")
    end

    it "should add new object to stack" do
      parser.object_stack.size.should == 1
    end
  end

  context "when detecting other tag opening" do
    before do
      parser.start_element("other")
    end

    it "should not add new object to stack" do
      parser.object_stack.should be_empty
    end
  end

  context "with non-empty object stack" do
    before do
      parser.start_element("product")
      parser.object_stack.should_not be_empty
    end

    context "when detecting object tag opening" do
      before do
        parser.start_element("product")
      end

      it "should add new object to stack" do
        parser.object_stack.size.should == 2
      end
    end

    context "when detecting other tag opening" do
      before do
        parser.start_element("other")
      end

      it "should not add new object to stack" do
        parser.object_stack.size.should == 2
      end
    end

    context "when detecting any tag closing" do
      before do
        parser.end_element("any")
      end

      it "should pop object from stack" do
        parser.object_stack.should be_empty
      end
    end
  end
end
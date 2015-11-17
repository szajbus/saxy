require 'spec_helper'

describe Saxy::Parser do
  include FixturesHelper

  let(:parser) { Saxy::Parser.new(fixture_file("webstore.xml"), "product") }

  it "should accept string filename as xml_file" do
    xml_file = fixture_file("webstore.xml")
    parser = Saxy::Parser.new(xml_file, "product")
    parser.each.to_a.size.should == 2
  end

  it "should accept IO as xml_file" do
    xml_file = File.new(fixture_file("webstore.xml"))
    parser = Saxy::Parser.new(xml_file, "product")
    parser.each.to_a.size.should == 2
  end

  it "should have empty tag stack" do
    parser.tags.should == %w( )
  end

  it "should push/pop tag names on/from tag stack when going down/up the XML tree" do
    parser.tags.should == %w( )

    parser.start_element('webstore')
    parser.tags.should == %w( webstore )

    parser.start_element('products')
    parser.tags.should == %w( webstore products )

    parser.start_element('product')
    parser.tags.should == %w( webstore products product )

    parser.end_element('product')
    parser.tags.should == %w( webstore products )

    parser.end_element('products')
    parser.tags.should == %w( webstore )

    parser.end_element('webstore')
    parser.tags.should == %w( )
  end

  context "when detecting object tag opening" do
    before do
      parser.start_element("product")
    end

    it "should add new element to stack" do
      parser.elements.size.should == 1
    end
  end

  context "when detecting other tag opening" do
    before do
      parser.start_element("other")
    end

    it "should not add new element to stack" do
      parser.elements.should be_empty
    end
  end

  context "with non-empty element stack" do
    before do
      parser.start_element("product")
      parser.elements.should_not be_empty
    end

    context "when detecting object tag opening" do
      before do
        parser.start_element("product")
      end

      it "should add new element to stack" do
        parser.elements.size.should == 2
      end
    end

    context "when detecting other tag opening" do
      before do
        parser.start_element("other")
      end

      it "should not add new element to stack" do
        parser.elements.size.should == 2
      end
    end

    context "when detecting any tag closing" do
      before do
        parser.end_element("any")
      end

      it "should pop element from stack" do
        parser.elements.should be_empty
      end
    end

    context "with callback defined" do
      before do
        @callback = lambda { |object| object }
        parser.stub(:callback).and_return(@callback)
      end

      it "should yield the object inside the callback after detecting object tag closing" do
        @callback.should_receive(:call).with(parser.current_element.to_h)
        parser.end_element("product")
      end

      it "should not yield the object inside the callback after detecting other tag closing" do
        parser.start_element("other")
        @callback.should_not_receive(:call)
        parser.end_element("other")
      end
    end

    it "should append cdata block's contents to top element's value when detecting cdata block" do
      parser.current_element.should_receive(:append_value).with("foo")
      parser.cdata_block("foo")
    end

    it "should append characters to top element's value when detecting characters block" do
      parser.current_element.should_receive(:append_value).with("foo")
      parser.current_element.should_receive(:append_value).with("bar")
      parser.characters("foo")
      parser.characters("bar")
    end

    it "should set element's attribute after processing tags" do
      element = parser.current_element

      element.should_receive(:set_attribute).with("foo", "bar")

      parser.start_element("foo")
      parser.characters("bar")
      parser.end_element("foo")
    end

    it "should set element's attributes when opening tag with attributes" do
      parser.start_element("foo", [["bar", "baz"]])
      parser.current_element.to_h[:bar].should == "baz"
    end
  end

  it "should raise Saxy::ParsingError on error" do
    lambda { parser.error("Error message.") }.should raise_error(Saxy::ParsingError, "Error message.")
  end

  it "should return Enumerator when calling #each without a block" do
    parser.each.should be_instance_of Enumerator
  end

end

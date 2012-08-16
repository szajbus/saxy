require 'spec_helper'

describe Saxy::Parser do
  include FixturesHelper

  let(:parser) { Saxy::Parser.new(fixture_file("webstore.xml"), "product") }

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

    it "should add new object to stack" do
      parser.objects.size.should == 1
    end
  end

  context "when detecting other tag opening" do
    before do
      parser.start_element("other")
    end

    it "should not add new object to stack" do
      parser.objects.should be_empty
    end
  end

  context "with non-empty object stack" do
    before do
      parser.start_element("product")
      parser.objects.should_not be_empty
    end

    context "when detecting object tag opening" do
      before do
        parser.start_element("product")
      end

      it "should add new object to stack" do
        parser.objects.size.should == 2
      end
    end

    context "when detecting other tag opening" do
      before do
        parser.start_element("other")
      end

      it "should not add new object to stack" do
        parser.objects.size.should == 2
      end
    end

    context "when detecting any tag closing" do
      before do
        parser.end_element("any")
      end

      it "should pop object from stack" do
        parser.objects.should be_empty
      end
    end

    context "with callback defined" do
      before do
        @callback = lambda { |object| object }
        parser.stub(:callback).and_return(@callback)
      end

      it "should yield the object inside the callback after detecting object tag closing" do
        @callback.should_receive(:call).with(parser.objects.last)
        parser.end_element("product")
      end

      it "should not yield the object inside the callback after detecting other tag closing" do
        parser.start_element("other")
        @callback.should_not_receive(:call)
        parser.end_element("other")
      end
    end

    context "when detecting cdata block" do
      before do
        parser.cdata_block("foo")
      end

      it "should replace top object in object stack with it's contents" do
        parser.objects.last.should == "foo"
      end
    end

    context "when detecting characters block" do
      before do
        parser.characters("foo")
      end

      it "should replace top object in object stack with it's contents" do
        parser.objects.last.should == "foo"
      end
    end

    context "when detecting multiple characters blocks" do
      before do
        parser.characters("foo")
        parser.characters("bar")
      end

      it "should replace top object in object stack with their concatenated contents" do
        parser.objects.last.should == "foobar"
      end
    end

    it "should set object's attribute after processing tags" do
      object = parser.objects.last

      parser.start_element("foo")
      parser.characters("bar")
      parser.end_element("foo")

      object.foo.should == "bar"
    end

    it "should underscore object's attribute names" do
      object = parser.objects.last

      parser.start_element("FooBar")
      parser.characters("baz")
      parser.end_element("FooBar")

      object.foo_bar.should == "baz"
    end
  end

  it "should raise Saxy::ParsingError on error" do
    lambda { parser.error("Error message.") }.should raise_error(Saxy::ParsingError, "Error message.")
  end
end
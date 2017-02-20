require 'spec_helper'

describe Saxy::Parser do
  include FixturesHelper

  let(:parser) { Saxy::Parser.new(fixture_file("webstore.xml"), "product", "UTF-8") }
  let(:file_io) { File.new(fixture_file("webstore.xml")) }
  let(:io_like) { IOLike.new(file_io) }

  it "should accept string filename for parsing" do
    xml_file = fixture_file("webstore.xml")
    parser = Saxy::Parser.new(xml_file, "product")
    expect(parser.each.to_a.size).to eq(2)
  end

  it "should accept IO for parsing" do
    parser = Saxy::Parser.new(file_io, "product")
    expect(parser.each.to_a.size).to eq(2)
  end

  it "should accept optional force-encoding" do
    parser = Saxy::Parser.new(file_io, "product", 'UTF-8')
    expect(Nokogiri::XML::SAX::Parser).to receive(:new).with(parser, "UTF-8").and_call_original
    expect(parser.each.to_a.size).to eq(2)
  end

  it "should accept an IO-like for parsing" do
    parser = Saxy::Parser.new(io_like, "product")
    expect(parser.each.to_a.size).to eq(2)
  end

  it "should have empty tag stack" do
    expect(parser.tags).to eq(%w( ))
  end

  it "should push/pop tag names on/from tag stack when going down/up the XML tree" do
    expect(parser.tags).to eq(%w( ))

    parser.start_element('webstore')
    expect(parser.tags).to eq(%w( webstore ))

    parser.start_element('products')
    expect(parser.tags).to eq(%w( webstore products ))

    parser.start_element('product')
    expect(parser.tags).to eq(%w( webstore products product ))

    parser.end_element('product')
    expect(parser.tags).to eq(%w( webstore products ))

    parser.end_element('products')
    expect(parser.tags).to eq(%w( webstore ))

    parser.end_element('webstore')
    expect(parser.tags).to eq(%w( ))
  end

  context "when detecting object tag opening" do
    before do
      parser.start_element("product")
    end

    it "should add new element to stack" do
      expect(parser.elements.size).to eq(1)
    end
  end

  context "when detecting other tag opening" do
    before do
      parser.start_element("other")
    end

    it "should not add new element to stack" do
      expect(parser.elements).to be_empty
    end
  end

  context "with non-empty element stack" do
    before do
      parser.start_element("product")
      expect(parser.elements).to_not be_empty
    end

    context "when detecting object tag opening" do
      before do
        parser.start_element("product")
      end

      it "should add new element to stack" do
        expect(parser.elements.size).to eq(2)
      end
    end

    context "when detecting other tag opening" do
      before do
        parser.start_element("other")
      end

      it "should not add new element to stack" do
        expect(parser.elements.size).to eq(2)
      end
    end

    context "when detecting any tag closing" do
      before do
        parser.end_element("any")
      end

      it "should pop element from stack" do
        expect(parser.elements).to be_empty
      end
    end

    context "with callback defined" do
      before do
        @callback = lambda { |object| object }
        allow(parser).to receive(:callback).and_return(@callback)
      end

      it "should yield the object inside the callback after detecting object tag closing" do
        expect(@callback).to receive(:call).with(parser.current_element.to_h)
        parser.end_element("product")
      end

      it "should not yield the object inside the callback after detecting other tag closing" do
        parser.start_element("other")
        expect(@callback).to_not receive(:call)
        parser.end_element("other")
      end
    end

    it "should append cdata block's contents to top element's value when detecting cdata block" do
      expect(parser.current_element).to receive(:append_value).with("foo")
      parser.cdata_block("foo")
    end

    it "should append characters to top element's value when detecting characters block" do
      expect(parser.current_element).to receive(:append_value).with("foo")
      expect(parser.current_element).to receive(:append_value).with("bar")
      parser.characters("foo")
      parser.characters("bar")
    end

    it "should set element's attribute after processing tags" do
      element = parser.current_element

      expect(element).to receive(:set_attribute).with("foo", "bar")

      parser.start_element("foo")
      parser.characters("bar")
      parser.end_element("foo")
    end

    it "should set element's attributes when opening tag with attributes" do
      parser.start_element("foo", [["bar", "baz"]])
      expect(parser.current_element.to_h[:bar]).to eq("baz")
    end
  end

  it "should raise Saxy::ParsingError on error" do
    expect { parser.error("Error message.") }.to raise_error(Saxy::ParsingError, "Error message.")
  end

  it "should return Enumerator when calling #each without a block" do
    expect(parser.each).to be_an(Enumerator)
  end
end

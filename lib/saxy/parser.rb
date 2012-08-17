require 'nokogiri'

module Saxy
  class Parser < Nokogiri::XML::SAX::Document
    include Enumerable

    # Stack of XML tags built while traversing XML tree
    attr_reader :tags

    # Stack of elements built while traversing XML tree
    #
    # First element is pushed to the stack only after finding the object_tag in
    # the XML tree.
    attr_reader :elements

    # Will yield objects inside the callback after they're built
    attr_reader :callback

    def initialize(xml_file, object_tag)
      @xml_file, @object_tag = xml_file, object_tag
      @tags, @elements = [], []
    end

    def start_element(tag, attributes=[])
      @tags << tag

      if tag == @object_tag || elements.any?
        elements << Element.new
      end
    end

    def end_element(tag)
      tags.pop
      if element = elements.pop
        object = element.as_object

        if current_element
          current_element.set_attribute(tag, object)
        elsif callback
          callback.call(object)
        end
      end
    end

    def cdata_block(cdata)
      current_element.append_value(cdata) if current_element
    end

    def characters(chars)
      current_element.append_value(chars) if current_element
    end

    def error(message)
      raise ParsingError.new(message)
    end

    def current_element
      elements.last
    end

    def each(&blk)
      if blk
        @callback = blk

        parser = Nokogiri::XML::SAX::Parser.new(self)
        parser.parse_file(@xml_file)
      else
        (RUBY_VERSION =~ /^1\.8/ ? Enumerable::Enumerator : Enumerator).new(self, :each)
      end
    end
  end
end
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

    def initialize(object, object_tag)
      @object, @object_tag = object, object_tag
      @tags, @elements = [], []
    end

    def start_element(tag, attributes=[])
      @tags << tag

      if tag == @object_tag || elements.any?
        elements << Element.new

        attributes.each do |(attr, value)|
          current_element.set_attribute(attr, value)
        end
      end
    end

    def end_element(tag)
      tags.pop
      if element = elements.pop
        object = element.to_h

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
      return to_enum unless blk

      @callback = blk

      parser = Nokogiri::XML::SAX::Parser.new(self)

      if @object.respond_to?(:read) && @object.respond_to?(:close)
        parser.parse_io(@object)
      else
        parser.parse_file(@object)
      end
    end
  end
end

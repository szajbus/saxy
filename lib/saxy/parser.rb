require 'active_support/core_ext/string/inflections'
require 'nokogiri'
require 'ostruct'

module Saxy
  class Parser < Nokogiri::XML::SAX::Document
    include Enumerable

    # Stack of XML tags built while traversing XML tree
    attr_reader :tags

    # Stack of objects built while traversing XML tree
    #
    # First object is pushed to the stack only after finding the object_tag in
    # the XML tree.
    attr_reader :objects

    # Will yield objects inside the callback after they're built
    attr_reader :callback

    def initialize(xml_file, object_tag)
      @xml_file, @object_tag = xml_file, object_tag
      @tags, @objects = [], []
    end

    def start_element(tag, attributes=[])
      @tags << tag

      if tag == @object_tag || objects.any?
        objects << OpenStruct.new
      end
    end

    def end_element(tag)
      tags.pop
      object = objects.pop

      if objects.any?
        objects.last.send("#{attribute_name(tag)}=", object)
      elsif callback
        callback.call(object)
      end
    end

    def cdata_block(cdata)
      if objects.last
        objects.pop
        objects << cdata
      end
    end

    def characters(chars)
      if objects.last.is_a?(OpenStruct)
        objects.pop
        objects << ""
      elsif objects.last
        objects.last << chars.strip
      end
    end

    def error(message)
      raise ParsingError.new(message)
    end

    def attribute_name(tag)
      tag.underscore
    end

    def each(&blk)
      @callback = blk

      parser = Nokogiri::XML::SAX::Parser.new(self)
      parser.parse_file(@xml_file)
    end
  end
end
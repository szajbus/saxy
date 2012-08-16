require 'active_support/core_ext/string/inflections'
require 'ostruct'

module Saxy
  class Parser
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
      objects.pop
      objects << cdata
    end

    def characters(chars)
      if objects.last.is_a?(OpenStruct)
        objects.pop
        objects << ""
      end

      objects.last << chars.strip
    end

    def attribute_name(tag)
      tag.underscore
    end
  end
end
require 'ostruct'

module Saxy
  class Parser
    # Stack of XML tags built while traversing XML tree
    attr_reader :tag_stack

    # Stack of objects built while traversing XML tree
    #
    # First object is pushed to the stack only after finding the object_tag in
    # the XML tree.
    attr_reader :object_stack

    # Attribute value built from CDATA or char blocks
    attr_reader :attribute_value

    def initialize(xml_file, object_tag)
      @xml_file, @object_tag = xml_file, object_tag
      @tag_stack, @object_stack = [], []
    end

    def start_element(tag, attributes=[])
      @tag_stack << tag

      if tag == @object_tag || @object_stack.any?
        @object_stack << OpenStruct.new
      end
    end

    def end_element(tag)
      @tag_stack.pop
      @object_stack.pop
      @attribute_value = nil
    end

    def cdata_block(cdata)
      @attribute_value = cdata
    end

    def characters(chars)
      @attribute_value ||= ""
      @attribute_value << chars.strip
    end
  end
end
require 'ostruct'

module Saxy
  class Parser
    attr_reader :tag_stack, :object

    def initialize(xml_file, object_tag)
      @xml_file, @object_tag = xml_file, object_tag
      @tag_stack = []
    end

    def start_element(tag, attributes=[])
      @tag_stack << tag

      if tag == @object_tag
        @object = OpenStruct.new
      end
    end

    def end_element(tag)
      @tag_stack.pop

      if tag == @object_tag
        @object = nil
      end
    end
  end
end
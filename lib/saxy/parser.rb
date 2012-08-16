require 'ostruct'

module Saxy
  class Parser
    attr_reader :tag_stack, :object_stack

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
    end
  end
end
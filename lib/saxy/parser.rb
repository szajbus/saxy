module Saxy
  class Parser
    attr_reader :stack

    def initialize(xml_file, object_tag)
      @xml_file, @object_tag = xml_file, object_tag
      @stack = []
    end

    def start_element(tag, attributes=[])
      @stack << tag
    end

    def end_element(tag)
      @stack.pop
    end
  end
end
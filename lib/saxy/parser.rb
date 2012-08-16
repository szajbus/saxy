require 'active_support'
require 'nokogiri'

module Saxy
  class Parser < Nokogiri::XML::SAX::Document
    include Enumerable

    def initialize(source_file, matches={})
      @source_file, @matches = source_file, matches
    end

    def start_element(name, attributes=[])
      @element_stack << name

      if klass = @matches[name]
        @object_stack << klass.new
      end
    end

    def end_element(name)
      if current_object
        if current_object.class == @matches[name]
          @callback.call(current_object)
          @object_stack.pop
        else
          current_object.send("#{attribute_name(name)}=", current_value)
        end
      end

      @element_stack.pop
      @value_chunks = []
    end

    def cdata_block(cdata)
      @value_chunks << cdata
    end

    def characters(chars)
      @value_chunks << chars
    end

    def error(msg)
      raise msg.inspect
    end

    def current_object
      @object_stack.last
    end

    def current_value
      @value_chunks.join("")
    end

    def attribute_name(name)
      name.underscore
    end

    def each(&blk)
      raise ArgumentError.new("No block given.") unless blk

      @callback      = blk
      @element_stack = []
      @object_stack  = []
      @value_chunks  = []

      parser = Nokogiri::XML::SAX::Parser.new(self)
      parser.parse_file(@source_file)
    end
  end
end
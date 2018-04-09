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

    # Parser context
    attr_reader :context

    # Parser options
    attr_reader :options

    def initialize(object, object_tag, options={})
      @object, @object_tag, @options = object, object_tag, options
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
      error = ParsingError.new(message, context)

      if options[:error_handler].respond_to?(:call)
        options[:error_handler].call(error)
      else
        raise error
      end
    end

    def current_element
      elements.last
    end

    def each(&blk)
      return to_enum unless blk

      @callback = blk

      args = [self, options[:encoding]].compact

      parser = Nokogiri::XML::SAX::Parser.new(*args)

      if @object.respond_to?(:read) && @object.respond_to?(:close)
        parser.parse_io(@object, &context_blk)
      else
        parser.parse_file(@object, &context_blk)
      end
    end

    def context_blk
      proc { |context|
        [:recovery, :replace_entities].each do |key|
          context.send("#{key}=", options[key]) if options.has_key?(key)
        end

        @context = context
      }
    end
  end
end

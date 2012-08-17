require 'active_support/core_ext/string/inflections'
require 'ostruct'

module Saxy
  class Element
    attr_reader :attributes, :value

    def initialize
      @attributes = {}
      @value = nil
    end

    def set_attribute(name, value)
      attributes[attribute_name(name)] = value
    end

    def append_value(string)
      unless (string = string.strip).empty?
        @value ||= ""
        @value << string
      end
    end

    def as_object
      attributes.any? ? OpenStruct.new(attributes) : value
    end

    def attribute_name(name)
      name.underscore
    end
  end
end
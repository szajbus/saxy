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
      name = attribute_name(name)
      attributes[name] ||= []
      attributes[name] << value
    end

    def append_value(string)
      unless (string = string.strip).empty?
        @value ||= ""
        @value << string
      end
    end

    def as_object
      if attributes.any?
        object = OpenStruct.new
        attributes.each do |name, value|
          value = value.first if value.size == 1
          object.send("#{name}=", value)
        end
        object
      else
        value
      end
    end

    def attribute_name(name)
      name.underscore
    end
  end
end
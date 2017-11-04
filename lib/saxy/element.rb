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

    def to_h
      return value unless attributes.any?
      data = attributes.reduce({}) do |memo, (name, value)|
        memo[name] = value.size == 1 ? value.first : value
        memo
      end
      data["contents"] = value
      data
    end

    def attribute_name(name)
      underscore(name)
    end

    private

    def underscore(word)
      word = word.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end

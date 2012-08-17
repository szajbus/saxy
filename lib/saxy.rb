require "saxy/parser"
require "saxy/parsing_error"
require "saxy/version"

module Saxy
  class << self
    def parse(xml_file, object_tag)
      Parser.new(xml, object_tag)
    end
  end
end

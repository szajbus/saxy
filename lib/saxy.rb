require 'saxy/version'

module Saxy
  class << self
    def parse(xml_file, object_tag, &blk)
      parser = Parser.new(xml_file, object_tag)

      if blk
        parser.each(blk)
      else
        parser.each
      end
    end

    def ruby_18?
      @ruby_18 ||= RUBY_VERSION =~ /^1\.8/
    end
  end
end

require 'saxy/element'
require 'saxy/ostruct'
require 'saxy/parser'
require 'saxy/parsing_error'

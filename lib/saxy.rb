require 'saxy/version'

module Saxy
  class << self
    def parse(object, object_tag, options={}, &blk)
      parser = Parser.new(object, object_tag, options)

      if blk
        parser.each(blk)
      else
        parser.each
      end
    end

  end
end

require 'saxy/element'
require 'saxy/parser'
require 'saxy/parsing_error'

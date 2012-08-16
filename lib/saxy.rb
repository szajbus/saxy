require "saxy/parser"
require "saxy/version"

module Saxy
  class << self
    def parse(file, matches={})
      parser = Parser.new(file, matches)
    end
  end
end

module Saxy
  class ParsingError < ::StandardError
    attr_reader :context

    def initialize(message, context)
      @context = context
      super(message)
    end
  end
end

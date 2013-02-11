require 'ostruct'

module Saxy
  class OpenStruct < ::OpenStruct
    if Saxy.ruby_18?
      define_method :id do
        @table[:id]
      end
    end
  end
end

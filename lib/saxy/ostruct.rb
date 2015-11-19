require 'ostruct'

module Saxy
  class OpenStruct < ::OpenStruct
    define_method :id do
      @table[:id]
    end
  end
end

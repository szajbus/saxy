require 'forwardable'

class IOLike
  extend ::Forwardable

  def_delegators :@io, :read, :close

  def initialize(io)
    @io = io
  end
end

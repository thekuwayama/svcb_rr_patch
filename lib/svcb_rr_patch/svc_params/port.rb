# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Port
  attr_reader :port

  # @param port [Integer]
  def initialize(port)
    @port = port
  end

  # @return [String]
  def encode
    [@port].pack('n')
  end

  # :nodoc:
  def self.decode(octet)
    port = octet.unpack1('n')
    new(port)
  end
end

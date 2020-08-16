# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::Port
  attr_reader :port

  # @param port [Integer]
  def initialize(port)
    @port = port
  end

  # :nodoc:
  def self.decode(octet)
    port = octet.unpack1('n1')
    new(port)
  end
end

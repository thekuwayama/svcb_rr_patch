# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig::HkpeKemId
  attr_reader :uint16

  # @param uint16 [Integer]
  def initialize(uint16)
    @uint16 = uint16
  end

  # @return [String]
  def encode
    [@uint16].pack('n')
  end

  # :nodoc
  def self.decode(octet)
    raise ::Resolv::DNS::DecodeError if octet.length != 2

    new(octet.unpack1('n'))
  end
end

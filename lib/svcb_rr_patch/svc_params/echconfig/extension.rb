# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig::Extension
  attr_reader :octet

  # @param octet [String]
  def initialize(octet)
    @octet = octet
  end

  # @return [String]
  def encode
    @octet
  end

  # :nodoc:
  def self.decode(octet)
    new(octet)
  end
end

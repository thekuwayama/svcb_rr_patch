# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::NoName
  attr_reader :octet

  # :nodoc:
  def initialize(octet)
    @octet = octet
  end

  # :nodoc:
  def self.decode(octet)
    new(octet)
  end
end

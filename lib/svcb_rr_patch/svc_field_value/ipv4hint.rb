# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::Ipv4hint
  attr_reader :addresses

  # @param addresses [Array of Resolv::IPv4]
  def initialize(addresses)
    @addresses = addresses
  end

  # :nodoc:
  def self.decode(octet)
    addresses = octet.scan(/.{1,4}/).map { |s| Resolv::IPv4.new(s) }
    new(addresses)
  end
end

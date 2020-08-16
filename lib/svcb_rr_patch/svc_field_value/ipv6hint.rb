# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::Ipv6hint
  attr_reader :addresses

  # @param addresses [Array of Resolv::IPv6]
  def initialize(addresses)
    @addresses = addresses
  end

  # :nodoc:
  def self.decode(octet)
    addresses = octet.scan(/.{1,16}/).map { |s| Resolv::IPv6.new(s) }
    new(addresses)
  end
end
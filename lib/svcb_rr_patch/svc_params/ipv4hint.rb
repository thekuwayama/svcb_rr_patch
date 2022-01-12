# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Ipv4hint
  attr_reader :addresses

  # @param addresses [Array of Resolv::IPv4]
  def initialize(addresses)
    @addresses = addresses
  end

  # @return [String]
  def encode
    @addresses.map(&:address).join
  end

  # :nodoc:
  def self.decode(octet)
    addresses = octet.scan(/.{1,4}/).map { |s| Resolv::IPv4.new(s) }
    new(addresses)
  end

  # :nodoc:
  def inspect
    @addresses.join(',')
  end
end

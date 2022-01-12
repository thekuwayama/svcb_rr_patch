# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Mandatory
  attr_reader :keys

  # @param keys [Array of Integer]]
  def initialize(keys)
    @keys = keys
  end

  # @return [String]
  def encode
    @keys.sort.map { |k| [k].pack('n') }.join
  end

  # :nodoc:
  def self.decode(octet)
    keys = octet.scan(/.{1,2}/).map { |s| s.unpack1('n') }
    new(keys)
  end

  # :nodoc:
  # rubocop: disable Metrics/CyclomaticComplexity
  def inspect
    @keys.map do |i|
      case i
      when 0
        'mandatory'
      when 1
        'alpn'
      when 2
        'no-default-alpn'
      when 3
        'port'
      when 4
        'ipv4hint'
      when 5
        'ech'
      when 6
        'ipv6hint'
      else
        "key#{i}"
      end
    end.join(',')
  end
  # rubocop: enable Metrics/CyclomaticComplexity
end

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
    keys = octet.scan(/.{1,2}/)
                .map { |s| s.unpack1('n') }
    new(keys)
  end

  # :nodoc:
  def to_s
    @keys.map { |i| SvcbRrPatch::SvcParams::PARAMETER_REGISTRY[i] }
         .join(',')
  end
end

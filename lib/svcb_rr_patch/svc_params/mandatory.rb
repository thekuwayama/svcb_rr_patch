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
                .filter { |i| i < 7 || i >= 65280 && i < 65535 }
    new(keys)
  end

  # :nodoc:
  def inspect
    @keys.map do |i|
      if i < 7
        SvcbRrPatch::SvcParams::PARAMETER_REGISTRY[i]
      elsif i >= 65280 && i < 65535
        "key#{i}"
      else
        ''
      end
    end.join(',')
  end
end

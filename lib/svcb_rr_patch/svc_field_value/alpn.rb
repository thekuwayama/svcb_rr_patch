# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::Alpn
  attr_reader :protocols

  # @param protocols [Array of String]
  def initialize(protocols)
    @protocols = protocols
  end

  # :nodoc:
  def self.decode(octet)
    protocols = []
    i = 0
    while i < octet.length
      raise Exception if i + 1 > octet.length

      id_len = octet.slice(i, 1).unpack1('C1')
      i += 1
      protocols << octet.slice(i, id_len)
      i += id_len
    end
    raise Exception if i != octet.length

    new(protocols)
  end
end

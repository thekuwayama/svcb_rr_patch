# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig::ECHConfigContents::Extension
  attr_reader :octet

  # @param octet [String]
  def initialize(octet)
    @octet = octet
  end

  # @return [String]
  def encode
    @octet
  end

  # @return [Array of Extension]
  def self.decode_vectors(octet)
    i = 0
    extensions = []
    while i < octet.length
      raise ::Resolv::DNS::DecodeError if i + 4 > octet.length

      ex_len = octet.slice(i + 2, 2)
      i += 4
      raise ::Resolv::DNS::DecodeError if i + ex_len > octet.length

      extensions << new(octet.slice(i, ex_len))
      i += ex_len
    end
    raise ::Resolv::DNS::DecodeError if i != octet.length

    extensions
  end
end

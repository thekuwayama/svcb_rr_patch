# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig
  attr_reader :echconfigs

  # @param echconfigs [Array of ECHConfig]
  def initialize(echconfigs)
    @echconfigs = echconfigs
  end

  # @return [String]
  def encode
    @echconfigs.map(&:encode).join.then { |s| [s.length].pack('n') + s }
  end

  # :nodoc:
  def self.decode(octet)
    b = nil
    begin
      b = Base64.strict_decode64(octet)
    rescue ArgumentError
      raise ::Resolv::DNS::DecodeError
    end

    raise ::Resolv::DNS::DecodeError \
      unless b.length == b.slice(0, 2).unpack1('n') + 2

    echconfigs = ECHConfig.decode_vectors(b.slice(2..))
    new(echconfigs)
  end

  class ECHConfig
    attr_reader :version
    attr_reader :echconfigcontents

    # https://tools.ietf.org/html/draft-ietf-tls-esni-07
    DRAFT_VERSION = "\xff\x07"
    private_constant :DRAFT_VERSION

    # @param echconfigcontents [ECHConfigContents]
    def initialize(echconfigcontents)
      @version = version
      @echconfigcontents = echconfigcontents
    end

    # @return [String]
    def encode
      @version + echconfigcontents.encode.then { |s| s.length.to_s + s }
    end

    # @return [Array of ECHConfig]
    def self.decode_vectors(octet)
      i = 0
      echconfigs = []
      while i < octet.length
        raise ::Resolv::DNS::DecodeError if i + 4 > octet.length

        version = octet.slice(i, i + 2)
        length = octet.slice(i + 2, i + 4).unpack1('n')
        i += 4
        raise ::Resolv::DNS::DecodeError if i + length > octet.length

        echcontents = ECHConfigContents.decode(octet.slice(i, i + length))
        i += length
        echconfigs += ECHConfig.new(version, echcontents)
      end
      raise ::Resolv::DNS::DecodeError if i != octet.length

      echconfigs
    end
  end
end

# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig
  attr_reader :echconfigs

  # @param echconfigs [Array of ECHConfig]
  def initialize(echconfigs)
    @echconfigs = echconfigs
  end

  # @return [String]
  def encode
    Base64.strict_encode64(
      @echconfigs.map(&:encode).join.then { |s| [s.length].pack('n') + s }
    )
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
end

require File.dirname(__FILE__) + '/echconfig/echconfig_contents.rb'

class SvcbRrPatch::SvcParams::Echconfig::ECHConfig
  attr_reader :version
  attr_reader :echconfigcontents

  # https://tools.ietf.org/html/draft-ietf-tls-esni-07
  DRAFT_VERSION = "\xff\x07"
  private_constant :DRAFT_VERSION

  ECHConfigContents = ::SvcbRrPatch::SvcParams::Echconfig::ECHConfigContents

  # @param echconfig_contents [ECHConfigContents]
  def initialize(echconfig_contents)
    @version = DRAFT_VERSION
    @echconfig_contents = echconfig_contents
  end

  # @return [String]
  def encode
    @version + @echconfig_contents.encode.then { |s| [s.length].pack('n') + s }
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

      echconfig_contents = ECHConfigContents.decode(octet.slice(i, i + length))
      i += length
      echconfigs << new(echconfig_contents)
    end
    raise ::Resolv::DNS::DecodeError if i != octet.length

    echconfigs
  end
end

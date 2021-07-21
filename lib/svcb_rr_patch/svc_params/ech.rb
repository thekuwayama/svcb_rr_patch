# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Ech
  attr_reader :echconfigs

  # @param echconfiglist [Array of ECHConfig]
  def initialize(echconfiglist)
    @echconfiglist = echconfiglist
  end

  # @return [String]
  def encode
    @echconfiglist.map(&:encode).join.then { |s| [s.length].pack('n') + s }
  end

  # :nodoc:
  def self.decode(octet)
    raise ::Resolv::DNS::DecodeError \
      unless octet.length == octet.slice(0, 2).unpack1('n') + 2

    echconfiglist = ECHConfig.decode_vectors(octet.slice(2..))
    new(echconfiglist)
  end
end

require_relative 'ech/echconfig_contents'

class SvcbRrPatch::SvcParams::Ech::ECHConfig
  attr_reader :version
  attr_reader :echconfigcontents

  ECHConfigContents = ::SvcbRrPatch::SvcParams::Ech::ECHConfigContents

  # @param version [String]
  # @param echconfig_contents [ECHConfigContents]
  def initialize(version, echconfig_contents)
    @version = version
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

      version = octet.slice(i, 2)
      length = octet.slice(i + 2, 2).unpack1('n')
      i += 4
      raise ::Resolv::DNS::DecodeError if i + length > octet.length

      echconfig_contents = ECHConfigContents.decode(octet.slice(i, length))
      i += length
      echconfigs << new(version, echconfig_contents)
    end
    raise ::Resolv::DNS::DecodeError if i != octet.length

    echconfigs
  end
end

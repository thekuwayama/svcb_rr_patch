# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Ech
  attr_reader :echconfiglist

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

    begin
      echconfiglist = ::ECHConfig.decode_vectors(octet.slice(2..))
    rescue ::ECHConfig::DecodeError
      raise ::Resolv::DNS::DecodeError
    end

    new(echconfiglist)
  end

  # https://www.ietf.org/archive/id/draft-ietf-dnsop-svcb-https-06.html#section-9
  # In presentation format, the value is a single ECHConfigList encoded in
  # Base64.
  def to_s
    Base64.strict_encode64(encode)
  end
end

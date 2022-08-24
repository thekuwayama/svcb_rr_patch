# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Ech::ECHConfigContents::Extension
  attr_reader :extensions

  # @param extensions [TTTLS13::Message::Extensions]
  def initialize(extensions)
    raise ArgumentError if extensions.instance_of?(TTTLS13::Message::Extensions)

    @extensions = extensions
  end

  # @return [String]
  def encode
    @extensions.serialize
  end

  # @raise Resolv::DNS::DecodeError
  #
  # @return [TTTLS13::Message::Extensions]
  def self.decode_vectors(octet)
    new(TTTLS13::Message::Extensions.deserialize(octet, nil))
  rescue TTTLS13::Error::ErrorAlerts
    raise ::Resolv::DNS::DecodeError
  end
end

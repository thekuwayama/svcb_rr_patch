# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Ech::ECHConfigContents::Extension
  attr_reader :extensions

  # @param extensions [TTTLS13::Message::Extensions]
  def initialize(extensions)
    @extensions = extensions
  end

  # @return [String]
  def encode
    @extensions.serialize
  end

  # @return [Array of Extension]
  def self.decode_vectors(octet)
    new(TTTLS13::Message::Extensions.deserialize(octet))
  rescue TTTLS13::Error::ErrorAlerts
    raise ::Resolv::DNS::DecodeError
  end
end

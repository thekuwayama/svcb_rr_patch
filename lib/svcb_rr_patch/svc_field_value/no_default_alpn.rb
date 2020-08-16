# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::NoDefaultAlpn <
      SvcbRrPatch::SvcFieldValue::Alpn
  # :nodec:
  def self.decode(octet)
    protocols = decode_protocols(octet)
    new(protocols)
  end
end

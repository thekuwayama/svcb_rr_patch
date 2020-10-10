# frozen_string_literal: true

class SvcbRrPatch::SvcParams::NoDefaultAlpn <
      SvcbRrPatch::SvcParams::Alpn
  # :nodec:
  def self.decode(octet)
    protocols = decode_protocols(octet)
    new(protocols)
  end
end

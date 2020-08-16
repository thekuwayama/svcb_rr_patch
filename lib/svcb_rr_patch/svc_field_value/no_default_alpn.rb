# frozen_string_literal: true

class SvcbRrPatch::SvcFieldValue::NoDefaultAlpn <
      SvcbRrPatch::SvcFieldValue::Alpn
  # :nodec:
  def self.decode(octet)
    alpn = ::SvcbRrPatch::SvcFieldValue::Alpn.decode(octet)
    new(alpn.protocols)
  end
end

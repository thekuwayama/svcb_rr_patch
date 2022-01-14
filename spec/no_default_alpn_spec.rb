# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::NoDefaultAlpn do
  let(:octet) do
    "\x05h3-29\x05h3-28\x05h3-27\x02h2"
  end

  context '#decode' do
    let(:no_default_alpn) do
      SvcbRrPatch::SvcParams::NoDefaultAlpn
        .decode(octet)
    end

    it 'could decode' do
      expect(no_default_alpn.protocols).to eq %w[h3-29 h3-28 h3-27 h2]
      expect(no_default_alpn)
        .to be_a(SvcbRrPatch::SvcParams::NoDefaultAlpn)
    end
  end

  context '#encode' do
    let(:no_default_alpn) do
      SvcbRrPatch::SvcParams::NoDefaultAlpn.new(%w[h3-29 h3-28 h3-27 h2])
    end

    it 'could encode' do
      expect(no_default_alpn)
        .to be_a(SvcbRrPatch::SvcParams::NoDefaultAlpn)
      expect(no_default_alpn.encode).to eq octet
      expect(no_default_alpn.to_s).to eq 'h3-29,h3-28,h3-27,h2'
    end
  end
end

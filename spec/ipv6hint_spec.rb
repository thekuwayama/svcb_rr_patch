# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::Ipv6hint do
  let(:octet) do
    "\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"
  end

  context '#decode' do
    let(:ipv6hint) do
      SvcbRrPatch::SvcParams::Ipv6hint.decode(octet)
    end

    it 'could decode' do
      expect(ipv6hint.addresses)
        .to eq [Resolv::IPv6.create('101:101:101:101:101:101:101:101')]
    end
  end

  context '#encode' do
    let(:ipv6hint) do
      SvcbRrPatch::SvcParams::Ipv6hint.new(
        [Resolv::IPv6.create('101:101:101:101:101:101:101:101')]
      )
    end

    it 'could encode' do
      expect(ipv6hint.encode).to eq octet
    end
  end
end

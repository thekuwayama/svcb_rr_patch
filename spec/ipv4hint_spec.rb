# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::Ipv4hint do
  let(:octet) do
    "\xc0\x00\x02\x01\xc0\x00\x02\x02"
  end

  context '#decode' do
    let(:ipv4hint) do
      SvcbRrPatch::SvcParams::Ipv4hint.decode(octet)
    end

    it 'could decode' do
      expect(ipv4hint.addresses).to eq [
        Resolv::IPv4.create('192.0.2.1'),
        Resolv::IPv4.create('192.0.2.2')
      ]
    end
  end

  context '#encode' do
    let(:ipv4hint) do
      SvcbRrPatch::SvcParams::Ipv4hint.new(
        [
          Resolv::IPv4.create('192.0.2.1'),
          Resolv::IPv4.create('192.0.2.2')
        ]
      )
    end

    it 'could encode' do
      expect(ipv4hint.encode).to eq octet
      expect(ipv4hint.inspect).to eq '192.0.2.1,192.0.2.2'
    end
  end
end

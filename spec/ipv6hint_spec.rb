# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::Ipv6hint do
  let(:octet) do
    <<-BIN.split.map(&:hex).map(&:chr).join
      20 01 0d b8 00 00 00 00     00 00 00 00 00 00 00 01
      20 01 0d b8 00 00 00 00     00 00 00 00 00 00 00 02
    BIN
  end

  context '#decode' do
    let(:ipv6hint) do
      SvcbRrPatch::SvcParams::Ipv6hint.decode(octet)
    end

    it 'could decode' do
      expect(ipv6hint.addresses).to eq [
        Resolv::IPv6.create('2001:db8::1'),
        Resolv::IPv6.create('2001:db8::2')
      ]
    end
  end

  context '#encode' do
    let(:ipv6hint) do
      SvcbRrPatch::SvcParams::Ipv6hint.new(
        [
          Resolv::IPv6.create('2001:db8::1'),
          Resolv::IPv6.create('2001:db8::2')
        ]
      )
    end

    it 'could encode' do
      expect(ipv6hint.encode).to eq octet
      expect(ipv6hint.inspect).to eq '2001:db8::1,2001:db8::2'
    end
  end
end

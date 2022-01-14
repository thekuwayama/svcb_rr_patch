# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams do
  let(:octet) do
    <<-BIN.split.map(&:hex).map(&:chr).join
      00 01 00 15 05 68 33 2d     32 39 05 68 33 2d 32 38
      05 68 33 2d 32 37 02 68     32 00 04 00 08 c0 a8 00
      01 c0 a8 00 02 00 06 00     10 20 01 0d b8 00 00 00
      00 00 00 00 00 00 00 00     01 ff 35 00 03 01 02 03
    BIN
  end

  let(:alpn) do
    SvcbRrPatch::SvcParams::Alpn.new(%w[h3-29 h3-28 h3-27 h2])
  end

  let(:ipv4hint) do
    SvcbRrPatch::SvcParams::Ipv4hint.new(
      [
        Resolv::IPv4.create('192.168.0.1'),
        Resolv::IPv4.create('192.168.0.2')
      ]
    )
  end

  let(:ipv6hint) do
    SvcbRrPatch::SvcParams::Ipv6hint.new(
      [Resolv::IPv6.create('2001:db8::1')]
    )
  end

  let(:key65333) do
    "\x01\x02\x03"
  end

  context '#keyNNNNN' do
    it 'could be defined' do
      expect(SvcbRrPatch::SvcParams::PARAMETER_REGISTRY[65333])
        .to eq 'key65333'
    end
  end

  context '#decode' do
    let(:svc_params) do
      SvcbRrPatch::SvcParams::Hash.decode(octet)
    end

    it 'could decode' do
      expect(svc_params.keys).to eq %w[alpn ipv4hint ipv6hint key65333]

      expect(svc_params['alpn'].protocols).to eq alpn.protocols
      expect(svc_params['ipv4hint'].addresses).to eq ipv4hint.addresses
      expect(svc_params['ipv6hint'].addresses).to eq ipv6hint.addresses
      expect(svc_params['key65333']).to eq key65333
    end
  end

  context '#encode' do
    let(:svc_params) do
      h = {
        'alpn' => alpn,
        'ipv4hint' => ipv4hint,
        'ipv6hint' => ipv6hint,
        'key65333' => key65333
      }
      SvcbRrPatch::SvcParams::Hash.new(h)
    end

    it 'could encode' do
      expect(svc_params.encode).to eq octet
      puts svc_params.inspect
    end
  end
end

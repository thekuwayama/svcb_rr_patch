# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue do
  let(:octet) do
    <<-BIN.split.map(&:hex).map(&:chr).join
      00 01 00 15 05 68 33 2d     32 39 05 68 33 2d 32 38
      05 68 33 2d 32 37 02 68     32 00 04 00 08 c0 a8 00
      01 c0 a8 00 02 00 06 00     10 01 01 01 01 01 01 01
      01 01 01 01 01 01 01 01     01 ff 35 00 03 01 02 03
    BIN
  end

  let(:alpn) do
    SvcbRrPatch::SvcFieldValue::Alpn.new(%w[h3-29 h3-28 h3-27 h2])
  end

  let(:ipv4hint) do
    SvcbRrPatch::SvcFieldValue::Ipv4hint.new(
      [
        Resolv::IPv4.create('192.168.0.1'),
        Resolv::IPv4.create('192.168.0.2')
      ]
    )
  end

  let(:ipv6hint) do
    SvcbRrPatch::SvcFieldValue::Ipv6hint.new(
      [Resolv::IPv6.create('101:101:101:101:101:101:101:101')]
    )
  end

  context '#keyNNNNN' do
    it 'could be defined' do
      expect(SvcbRrPatch::SvcFieldValue::PARAMETER_REGISTRY[65333])
        .to eq 'key65333'
    end
  end

  context '#decode' do
    let(:svc_field_value) do
      SvcbRrPatch::SvcFieldValue.decode(octet)
    end

    it 'could decode' do
      expect(svc_field_value.keys).to eq %w[alpn ipv4hint ipv6hint key65333]

      expect(svc_field_value['alpn'].protocols).to eq alpn.protocols
      expect(svc_field_value['ipv4hint'].addresses).to eq ipv4hint.addresses
      expect(svc_field_value['ipv6hint'].addresses).to eq ipv6hint.addresses
      expect(svc_field_value['key65333']).to eq "\x01\x02\x03"
    end
  end

  context '#decode' do
    let(:svc_field_value) do
      {
        'alpn' => alpn,
        'ipv4hint' => ipv4hint,
        'ipv6hint' => ipv6hint,
        'key65333' => "\x01\x02\x03"
      }
    end

    it 'could encode' do
      expect(SvcbRrPatch::SvcFieldValue.encode(svc_field_value)).to eq octet
    end
  end
end

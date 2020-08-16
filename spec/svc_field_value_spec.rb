# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue do
  context 'svc_field_value' do
    let(:octet) do
      <<-BIN.split.map(&:hex).map(&:chr).join
        00 01 00 15 05 68 33 2d     32 39 05 68 33 2d 32 38
        05 68 33 2d 32 37 02 68     32 00 04 00 08 c0 a8 00
        01 c0 a8 00 02 00 06 00     10 01 01 01 01 01 01 01
        01 01 01 01 01 01 01 01     01
      BIN
    end

    let(:svc_field_value) do
      SvcbRrPatch::SvcFieldValue.decode(octet)
    end

    it 'could decode' do
      expect(svc_field_value.keys).to eq %w[alpn ipv4hint ipv6hint]

      expect(svc_field_value['alpn'].protocols)
        .to eq %w[h3-29 h3-28 h3-27 h2]
      expect(svc_field_value['ipv4hint'].addresses).to eq [
        Resolv::IPv4.create('192.168.0.1'),
        Resolv::IPv4.create('192.168.0.2')
      ]
      expect(svc_field_value['ipv6hint'].addresses)
        .to eq [Resolv::IPv6.create('101:101:101:101:101:101:101:101')]
    end
  end
end

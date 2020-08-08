# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SVCB do
  context 'alpn' do
    let(:octet) do
      "\x05h3-29\x05h3-28\x05h3-27\x02h2"
    end

    it 'could parse' do
      expect(
        Resolv::DNS::Resource::IN::SVCB.send(
          :parse_alpn,
          octet
        )
      ).to eq ["h3-29", "h3-28", "h3-27", "h2"]
    end
  end

  context 'ipv4hint' do
    let(:octet) do
      "\xc0\xa8\x00\x01\xc0\xa8\x00\x02"
    end

    it 'could parse' do
      expect(
        Resolv::DNS::Resource::IN::SVCB.send(
          :parse_ipv4hint,
          octet
        )
      ).to eq [Resolv::IPv4.create("192.168.0.1"), Resolv::IPv4.create("192.168.0.2")]
    end
  end
end

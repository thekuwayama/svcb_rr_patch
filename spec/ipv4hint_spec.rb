# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::Ipv4hint do
  context 'ipv4hint' do
    let(:octet) do
      "\xc0\xa8\x00\x01\xc0\xa8\x00\x02"
    end

    let(:ipv4hint) do
      SvcbRrPatch::SvcFieldValue::Ipv4hint.decode(octet)
    end

    it 'could decode' do
      expect(ipv4hint.addresses).to eq [
        Resolv::IPv4.create('192.168.0.1'),
        Resolv::IPv4.create('192.168.0.2')
      ]
    end
  end
end

# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::Ipv6hint do
  context 'ipv6hint' do
    let(:octet) do
      "\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"
    end

    let(:ipv6hint) do
      SvcbRrPatch::SvcFieldValue::Ipv6hint.decode(octet)
    end

    it 'could decode' do
      expect(ipv6hint.addresses)
        .to eq [Resolv::IPv6.create('101:101:101:101:101:101:101:101')]
    end
  end
end

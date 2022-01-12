# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::Alpn do
  let(:octet) do
    "\x05h3-29\x05h3-28\x05h3-27\x02h2"
  end

  context '#decode' do
    let(:alpn) do
      SvcbRrPatch::SvcParams::Alpn.decode(octet)
    end

    it 'could decode' do
      expect(alpn.protocols).to eq %w[h3-29 h3-28 h3-27 h2]
    end
  end

  context '#encode' do
    let(:alpn) do
      SvcbRrPatch::SvcParams::Alpn.new(%w[h3-29 h3-28 h3-27 h2])
    end

    it 'could encode' do
      expect(alpn.encode).to eq octet
      expect(alpn.inspect).to eq 'h3-29,h3-28,h3-27,h2'
    end
  end
end

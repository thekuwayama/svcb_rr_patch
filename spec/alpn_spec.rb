# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::Alpn do
  context 'alpn' do
    let(:octet) do
      "\x05h3-29\x05h3-28\x05h3-27\x02h2"
    end

    let(:alpn) do
      SvcbRrPatch::SvcFieldValue::Alpn.decode(octet)
    end

    it 'could decode' do
      expect(alpn.protocols)
        .to eq %w[h3-29 h3-28 h3-27 h2]
    end
  end
end

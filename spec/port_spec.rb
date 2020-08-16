# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::Port do
  context 'port' do
    let(:octet) do
      "\x01\xbb"
    end

    let(:port) do
      SvcbRrPatch::SvcFieldValue::Port.decode(octet)
    end

    it 'could decode' do
      expect(port.port).to eq 443
    end
  end
end

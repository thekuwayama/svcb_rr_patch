# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::Port do
  let(:octet) do
    "\x01\xbb"
  end

  context '#decode' do
    let(:port) do
      SvcbRrPatch::SvcFieldValue::Port.decode(octet)
    end

    it 'could decode' do
      expect(port.port).to eq 443
    end
  end

  context '#encode' do
    let(:port) do
      SvcbRrPatch::SvcFieldValue::Port.new(443)
    end

    it 'could encode' do
      expect(port.encode).to eq octet
    end
  end
end

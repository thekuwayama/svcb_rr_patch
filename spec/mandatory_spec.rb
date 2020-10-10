# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::Mandatory do
  let(:octet) do
    "\x00\x05\xff\xa4"
  end

  let(:keys) do
    h = Hash[
      (0..SvcbRrPatch::SvcFieldValue::PARAMETER_REGISTRY.size - 1)
        .zip(SvcbRrPatch::SvcFieldValue::PARAMETER_REGISTRY)
    ].invert

    [h['echconfig'], h['key65444']]
  end

  context '#decode' do
    let(:mandatory) do
      SvcbRrPatch::SvcFieldValue::Mandatory.decode(octet)
    end

    it 'could decode' do
      expect(mandatory.keys).to eq keys
    end
  end

  context '#encode' do
    let(:mandatory) do
      SvcbRrPatch::SvcFieldValue::Mandatory.new(keys)
    end

    it 'could encode' do
      expect(mandatory.encode).to eq octet
    end
  end
end

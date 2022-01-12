# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::Mandatory do
  let(:octet) do
    "\x00\x05\xff\xa4"
  end

  let(:keys) do
    h = Hash[
      (0..SvcbRrPatch::SvcParams::PARAMETER_REGISTRY.size - 1)
        .zip(SvcbRrPatch::SvcParams::PARAMETER_REGISTRY)
    ].invert

    [h['ech'], h['key65444']]
  end

  context '#decode' do
    let(:mandatory) do
      SvcbRrPatch::SvcParams::Mandatory.decode(octet)
    end

    it 'could decode' do
      expect(mandatory.keys).to eq keys
    end
  end

  context '#encode' do
    let(:mandatory) do
      SvcbRrPatch::SvcParams::Mandatory.new(keys)
    end

    it 'could encode' do
      expect(mandatory.encode).to eq octet
      expect(mandatory.inspect).to eq 'ech,key65444'
    end
  end
end

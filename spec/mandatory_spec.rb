# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcParams::Mandatory do
  let(:octet) do
    "\x00\x05\x00\x06\x00\x08\xff\xa4"
  end

  let(:keys) do
    [
      SvcbRrPatch::SvcParams::PARAMETER_REGISTRY_INVERT['ech'],
      SvcbRrPatch::SvcParams::PARAMETER_REGISTRY_INVERT['ipv6hint'],
      SvcbRrPatch::SvcParams::PARAMETER_REGISTRY_INVERT['undefine8'],
      SvcbRrPatch::SvcParams::PARAMETER_REGISTRY_INVERT['key65444']
    ]
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
      expect(mandatory.to_s).to eq 'ech,ipv6hint,undefine8,key65444'
    end
  end
end

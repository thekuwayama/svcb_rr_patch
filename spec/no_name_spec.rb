# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SvcbRrPatch::SvcFieldValue::NoName do
  let(:octet) do
    "\x05h3-29\x05h3-28\x05h3-27\x02h2"
  end

  context '#decode' do
    let(:no_name) do
      SvcbRrPatch::SvcFieldValue::NoName.decode(octet)
    end

    it 'could decode' do
      expect(no_name.octet).to eq octet
    end
  end

  context '#encode' do
    let(:no_name) do
      SvcbRrPatch::SvcFieldValue::NoName.new(octet)
    end

    it 'could encode' do
      expect(no_name.encode).to eq octet
    end
  end
end

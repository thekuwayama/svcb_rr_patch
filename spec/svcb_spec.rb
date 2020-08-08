# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe SVCB do
  let(:octet) do
    "\x05h3-29\x05h3-28\x05h3-27\x02h2"
  end

  it 'could parse' do
    expect(
      Resolv::DNS::Resource::IN::SVCB.send(
        :parse_alpn,
        octet
      )
    ).to eq ["h3-29", "h3-28", "h3-27", "h2"]
  end
end

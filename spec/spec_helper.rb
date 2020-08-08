# frozen_string_literal: true

RSpec.configure(&:disable_monkey_patching!)

# rubocop: disable Style/MixinUsage
require 'svcb_rr_patch'
include Resolv::DNS::Resource::IN
# rubocop: enable Style/MixinUsage

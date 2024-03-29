# frozen_string_literal: true

##
# The HTTPS DNS Resource Record

class Resolv::DNS::Resource::IN::HTTPS < Resolv::DNS::Resource::IN::SVCB
  TypeValue = 65 # rubocop:disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  class << self
    # :nodoc:
    def decode_rdata(msg)
      svc_priority = msg.get_bytes(2).unpack1('n')
      target_name = msg.get_string
      return new(svc_priority, target_name, {}) if svc_priority.zero?

      # the SvcParams, consuming the remainder of the record
      svc_params = ::SvcbRrPatch::SvcParams::Hash.decode(msg.get_bytes)
      new(svc_priority, target_name, svc_params)
    end
  end
end

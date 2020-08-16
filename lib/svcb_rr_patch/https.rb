# frozen_string_literal: true

##
# The HTTPS DNS Resource Record

class Resolv::DNS::Resource::IN::HTTPS < Resolv::DNS::Resource::IN::SVCB
  TypeValue = 65 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  def initialize(svc_priority, svc_domain_name, svc_field_value)
    # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-https-00
    super(svc_priority, svc_domain_name, svc_field_value)
  end

  class << self
    # :nodoc:
    def decode_rdata(msg)
      svc_priority = msg.get_bytes(2).unpack1('n')
      svc_domain_name = msg.get_string
      return new(svc_priority, svc_domain_name, {}) if svc_priority.zero?

      # the SvcFieldValue, consuming the remainder of the record
      svc_field_value = ::SvcbRrPatch::SvcFieldValue.decode(msg.get_bytes)
      new(svc_priority, svc_domain_name, svc_field_value)
    end
  end
end

# frozen_string_literal: true

##
# The SVCB(contraction of "service binding") DNS Resource Record

class Resolv::DNS::Resource::IN::SVCB < Resolv::DNS::Resource
  TypeValue = 64 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  def initialize(svc_priority, svc_domain_name, svc_field_value)
    # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-https-00
    @svc_priority = svc_priority
    @svc_domain_name = svc_domain_name
    @svc_field_value = svc_field_value
  end

  ##
  # SvcPriority

  attr_reader :svc_priority

  ##
  # SvcDomainName

  attr_reader :svc_domain_name

  ##
  # SvcFieldValue

  attr_reader :svc_field_value

  # :nodoc:
  def encode_rdata(msg)
    msg.put_bytes([@svc_priority].pack('n1'))
    msg.put_string(@target_name)
    # TODO: encode SvcFieldValue
    # msg.put_string(encode_svc_field_value)
  end

  class << self
    # :nodoc:
    def decode_rdata(msg)
      svc_priority = msg.get_bytes(2).unpack1('n1')
      svc_domain_name = msg.get_string
      return new(svc_priority, svc_domain_name, {}) if svc_priority.zero?

      # the SvcFieldValue, consuming the remainder of the record
      svc_field_value = SvcbRrPatch::SvcFieldValue.decode(msg.get_bytes)
      new(svc_priority, svc_domain_name, svc_field_value)
    end
  end
end

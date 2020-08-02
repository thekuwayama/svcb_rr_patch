# frozen_string_literal: true

##
# The SVCB(contraction of "service binding") DNS Resource Record

# rubocop: disable Style/ClassAndModuleChildren
class Resolv::DNS::Resource::IN::SVCB < Resolv::DNS::Resource
  TypeValue = 64 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  def initialize(svc_priority, svc_domain_name, svc_field_value)
    # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-https-03
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
    msg.put_string(@svc_field_value.map { |k, v| "#{k}=#{v}" }.join(' '))
  end

  # :nodec:
  def self.decode_rdata(msg)
    svc_priority = msg.get_bytes(2).unpack1('n1')
    svc_domain_name = msg.get_string
    # TODO: AliasForm if svc_priority == 0
    s = msg.get_bytes
    i = 0
    svc_field_value = {}
    # TODO: parse SvcParamValue
    while i < s.length
      # TODO: raise Exception
      # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-httpssvc-03#section-12.1.2
      k = s.slice(i, 2)
      i += 2
      vlen = s.slice(i, 2).unpack1('n1')
      i += 2
      octet = s.slice(i, 1)
      i += 1
      # TODO: mapping SvcParamKey
      # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-httpssvc-03#section-6
      v = s.slice(i, vlen)
      i += vlen
      svc_field_value.store(k, [v, octet])
    end

    new(svc_priority, svc_domain_name, svc_field_value)
  end
end
# rubocop: enable Style/ClassAndModuleChildren

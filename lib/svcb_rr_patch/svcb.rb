# frozen_string_literal: true

##
# The SVCB(contraction of "service binding") DNS Resource Record

# rubocop: disable Style/ClassAndModuleChildren
class Resolv::DNS::Resource::IN::SVCB < Resolv::DNS::Resource
  TypeValue = 64 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  module ParameterRegistry
    MANDATORY       = "\x00\x00"
    ALPN            = "\x00\x01"
    NO_DEFAULT_ALPN = "\x00\x02"
    PORT            = "\x00\x03"
    IPV4HINT        = "\x00\x04"
    ECHCONFIG       = "\x00\x05"
    IPV6HINT        = "\x00\x06"
    (65280..65535).each { |nnnn| eval "KEY#{nnnn} = #{nnnn}" }
  end

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
    msg.put_string(@svc_field_value.map { |k, v| "#{k}=#{v}" }.join(' ')) # FIXME
  end

  # :nodec:
  def self.decode_rdata(msg)
    svc_priority = msg.get_bytes(2).unpack1('n1')
    svc_domain_name = msg.get_string
    svc_field_value = {}
    return new(svc_priority, svc_domain_name, svc_field_value) if svc_priority == 0

    s = msg.get_bytes
    i = 0
    # TODO: parse SvcParamValue
    while i < s.length
      raise Exception if i + 5 > s.length

      k = s.slice(i, 2).unpack1('n1')
      # SvcParamKeys SHALL appear in increasing numeric order.
      raise Exception unless svc_field_value.keys.find { |already| already >= k }.nil?

      i += 2
      vlen = s.slice(i, 2).unpack1('n1')
      i += 2
      octet = s.slice(i, 1)
      i += 1
      raise Exception if i + vlen > s.length

      # TODO: mapping SvcParamKey
      v = s.slice(i, vlen)
      i += vlen
      svc_field_value.store(k, [v, octet])
    end
    raise Exception if i != s.length

    new(svc_priority, svc_domain_name, svc_field_value)
  end
end
# rubocop: enable Style/ClassAndModuleChildren

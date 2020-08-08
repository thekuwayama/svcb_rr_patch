# frozen_string_literal: true

##
# The SVCB(contraction of "service binding") DNS Resource Record

# rubocop: disable Style/ClassAndModuleChildren
class Resolv::DNS::Resource::IN::SVCB < Resolv::DNS::Resource
  TypeValue = 65 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  ParameterRegistry = [
    'mandatory',
    'alpn',
    'no-default-alpn',
    'port',
    'ipv4hint',
    'echconfig',
    'ipv6hint'
  ]
  # (65280..65535).each { |nnnn| eval ParameterRegistry[nnnn] = "KEY#{nnnn}" }

  def initialize(svc_priority, svc_domain_name, svc_params)
    # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-https-03
    @svc_priority = svc_priority
    @svc_domain_name = svc_domain_name
    @svc_params = svc_params
  end

  ##
  # SvcPriority

  attr_reader :svc_priority

  ##
  # SvcDomainName

  attr_reader :svc_domain_name

  ##
  # SvcParams

  attr_reader :svc_params

  # :nodoc:
  def encode_rdata(msg)
    msg.put_bytes([@svc_priority].pack('n1'))
    msg.put_string(@target_name)
    msg.put_string(@svc_params.map { |k, v| "#{k}=#{v}" }.join(' ')) # FIXME
  end

  # :nodoc:
  def self.decode_rdata(msg)
    svc_priority = msg.get_bytes(2).unpack1('n1')
    svc_domain_name = msg.get_string
    return new(svc_priority, svc_domain_name, {}) if svc_priority.zero?

    # the SvcParams, consuming the remainder of the record
    svc_params = decode_svc_param_values(msg.get_bytes)
    new(svc_priority, svc_domain_name, svc_params)
  end

  class << self
    # :nodoc:
    def decode_svc_param_values(octet)
      svc_params = {}
      i = 0
      h = Hash[(0..ParameterRegistry.size).zip(ParameterRegistry)].invert
      while i < octet.length
        raise Exception if i + 5 > octet.length

        k = octet.slice(i, 2).unpack1('n1')
        # SvcParamKeys SHALL appear in increasing numeric order.
        raise Exception \
          unless svc_params.keys.find { |already| h[already] >= k }.nil?

        i += 2
        vlen = octet.slice(i, 2).unpack1('n1')
        i += 2
        raise Exception if i + vlen > octet.length

        v = octet.slice(i, vlen)
        i += vlen
        # Values are in a format specific to the SvcParamKey.
        svc_param_key = ParameterRegistry[k]
        svc_param_values = parse_svc_param_key(svc_param_key, v)
        svc_params.store(svc_param_key, svc_param_values)
      end
      raise Exception if i != octet.length

      svc_params
    end

    # :nodoc:
    def parse_svc_param_key(key, octet)
      case key
      when 'mandatory'
        parse_mandatory(octet)
      when 'alpn'
        parse_alpn(octet)
      when 'no-default-alpn'
        parse_alpn(octet)
      when 'port'
        parse_port(octet)
      when 'ipv4hint'
        parse_ipv4hint(octet)
      when 'echconfig'
        parse_echconfig(octet)
      when 'ipv6hint'
        parse_ipv6hint(octet)
      else
        [octet]
      end
    end

    # :nodoc:
    def parse_mandatory(octet)
      [octet]
    end

    # :nodoc:
    def parse_alpn(octet)
      alpns = []
      i = 0
      while i < octet.length
        raise Exception if i + 1 > octet.length

        id_len = octet.slice(i, 1).unpack1('C1')
        i += 1
        alpns << octet.slice(i, id_len)
        i += id_len
      end
      raise Exception if i != octet.length

      alpns
    end

    # :nodoc:
    def parse_port(octet)
      [octet]
    end

    # :nodoc:
    def parse_ipv4hint(octet)
      octet.scan(/.{1,4}/).map { |s| Resolv::IPv4.new(s) }
    end

    # :nodoc:
    def parse_echconfig(octet)
      [octet]
    end

    # :nodoc:
    def parse_ipv6hint(octet)
      [octet]
    end
  end
end
# rubocop: enable Style/ClassAndModuleChildren

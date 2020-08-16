# frozen_string_literal: true

module SvcbRrPatch::SvcFieldValue
  # initialize
end

Dir[File.dirname(__FILE__) + '/svc_field_value/*.rb']
  .sort.each { |f| require f }

module SvcbRrPatch::SvcFieldValue
  PARAMETER_REGISTRY = %w[
    no\ name
    alpn
    no-default-alpn
    port
    ipv4hint
    echconfig
    ipv6hint
  ].freeze
  # (65280..65535).each { |nnnn| eval PARAMETER_REGISTRY[nnnn] = "KEY#{nnnn}" }

  # @param octet [String]
  #
  # @return [Map]
  # rubocop: disable Metrics/AbcSize
  def decode(octet)
    svc_field_value = {}
    i = 0
    h = Hash[(0..PARAMETER_REGISTRY.size).zip(PARAMETER_REGISTRY)].invert
    while i < octet.length
      raise Exception if i + 4 > octet.length

      k = octet.slice(i, 2).unpack1('n1')
      # SvcParamKeys SHALL appear in increasing numeric order.
      raise Exception \
        unless svc_field_value.keys.find { |already| h[already] >= k }.nil?

      i += 2
      vlen = octet.slice(i, 2).unpack1('n1')
      i += 2
      raise Exception if i + vlen > octet.length

      v = octet.slice(i, vlen)
      i += vlen
      # Values are in a format specific to the SvcParamKey.
      svc_param_key = PARAMETER_REGISTRY[k]
      svc_param_values = decode_svc_field_value(svc_param_key, v)
      svc_field_value.store(svc_param_key, svc_param_values)
    end
    raise Exception if i != octet.length

    svc_field_value
  end
  # rubocop: enable Metrics/AbcSize

  private

  # :nodoc:
  # rubocop: disable Metrics/CyclomaticComplexity
  def decode_svc_field_value(key, octet)
    case key
    when 'no name'
      NoName.decode(octet)
    when 'alpn'
      Alpn.decode(octet)
    when 'no-default-alpn'
      NoDefaultAlpn.decode(octet)
    when 'port'
      Port.decode(octet)
    when 'ipv4hint'
      Ipv4hint.decode(octet)
    when 'echconfig'
      octet
    when 'ipv6hint'
      Ipv6hint.decode(octet)
    else
      octet
    end
  end
  # rubocop: enable Metrics/CyclomaticComplexity
end
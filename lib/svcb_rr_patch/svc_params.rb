# frozen_string_literal: true

module SvcbRrPatch::SvcParams
  PARAMETER_REGISTRY = lambda {
    registry = %w[
      mandatory
      alpn
      no-default-alpn
      port
      ipv4hint
      echconfig
      ipv6hint
    ]
    # rubocop:disable Security/Eval
    (65280..65535).each do |nnnn|
      eval "registry[nnnn] = \"key#{nnnn}\"", binding, __FILE__, __LINE__
    end
    # rubocop:enable Security/Eval
    registry
  }.call.freeze
end

Dir[File.dirname(__FILE__) + '/svc_params/*.rb'].sort.each { |f| require f }

module SvcbRrPatch::SvcParams
  # @return [String]
  def self.encode(svc_params)
    h = Hash[(0..PARAMETER_REGISTRY.size - 1).zip(PARAMETER_REGISTRY)].invert

    svc_params
      .map { |k, v| [h[k], v] }
      .sort { |lh, rh| lh.first <=> rh.first }
      .map do |k, v|
        [k].pack('n') + v.encode.then { |s| [s.length].pack('n') + s }
      end
      .join
  end

  # @param octet [String]
  #
  # @return [Hash] Integer => SvcbRrPatch::$Object
  # rubocop:disable Metrics/AbcSize
  def self.decode(octet)
    svc_params = {}
    i = 0
    h = Hash[(0..PARAMETER_REGISTRY.size - 1).zip(PARAMETER_REGISTRY)].invert
    while i < octet.length
      raise ::Resolv::DNS::DecodeError if i + 4 > octet.length

      k = octet.slice(i, 2).unpack1('n')
      # SvcParamKeys SHALL appear in increasing numeric order.
      raise ::Resolv::DNS::DecodeError \
        unless svc_params.keys.find { |already| h[already] >= k }.nil?

      i += 2
      vlen = octet.slice(i, 2).unpack1('n')
      i += 2
      raise ::Resolv::DNS::DecodeError if i + vlen > octet.length

      v = octet.slice(i, vlen)
      i += vlen
      # Values are in a format specific to the SvcParamKey.
      svc_param_key = PARAMETER_REGISTRY[k]
      svc_param_values = decode_svc_params(svc_param_key, v)
      svc_params.store(svc_param_key, svc_param_values)
    end
    raise ::Resolv::DNS::DecodeError if i != octet.length

    svc_params
  end
  # rubocop:enable Metrics/AbcSize

  # :nodoc:
  # rubocop:disable Metrics/CyclomaticComplexity
  def self.decode_svc_params(key, octet)
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
  # rubocop:enable Metrics/CyclomaticComplexity
end

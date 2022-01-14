# frozen_string_literal: true

module SvcbRrPatch::SvcParams
  PARAMETER_REGISTRY = lambda {
    registry = %w[
      mandatory
      alpn
      no-default-alpn
      port
      ipv4hint
      ech
      ipv6hint
    ]
    # rubocop:disable Security/Eval
    (8...65280).each do |nnnn|
      eval "registry[nnnn] = \"undefine#{nnnn}\"", binding, __FILE__, __LINE__
    end
    (65280...65535).each do |nnnn|
      eval "registry[nnnn] = \"key#{nnnn}\"", binding, __FILE__, __LINE__
    end
    # rubocop:enable Security/Eval
    registry
  }.call.freeze

  PARAMETER_REGISTRY_INVERT = lambda {
    Hash[(0..PARAMETER_REGISTRY.size - 1).zip(PARAMETER_REGISTRY)].invert
  }.call.freeze
end

Dir[File.dirname(__FILE__) + '/svc_params/*.rb'].sort.each { |f| require f }

module SvcbRrPatch::SvcParams
  class Hash
    def initialize(hash)
      @hash = hash
    end

    # @return [String]
    def encode
      @hash
        .map { |k, v| [PARAMETER_REGISTRY_INVERT[k], v] }
        .sort { |lh, rh| lh.first <=> rh.first }
        .map do |k, v|
          [k].pack('n') + v.encode.then { |s| [s.length].pack('n') + s }
        end
        .join
    end

    # @param octet [String]
    #
    # @return [Hash]
    def self.decode(octet)
      svc_params = {}
      i = 0
      while i < octet.length
        raise ::Resolv::DNS::DecodeError if i + 4 > octet.length

        k = octet.slice(i, 2).unpack1('n')
        # SvcParamKeys SHALL appear in increasing numeric order.
        raise ::Resolv::DNS::DecodeError unless svc_params.keys.find do |key|
          PARAMETER_REGISTRY_INVERT[key] >= k
        end.nil?

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

      new(svc_params)
    end

    # :nodoc:
    # rubocop:disable Metrics/CyclomaticComplexity
    def self.decode_svc_params(key, octet)
      case key
      when 'mandatory'
        Mandatory.decode(octet)
      when 'alpn'
        Alpn.decode(octet)
      when 'no-default-alpn'
        NoDefaultAlpn.decode(octet)
      when 'port'
        Port.decode(octet)
      when 'ipv4hint'
        Ipv4hint.decode(octet)
      when 'ech'
        Ech.decode(octet)
      when 'ipv6hint'
        Ipv6hint.decode(octet)
      else
        octet
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    # :nodoc:
    def [](key)
      @hash[key]
    end

    # :nodoc:
    def keys
      @hash.keys
    end

    # :nodoc:
    def inspect
      @hash.map { |k, v| "#{k}=#{v.inspect}" }.join(' ')
    end
  end
end

# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig::ECHConfigContents
  attr_reader :public_name
  attr_reader :public_key
  attr_reader :kem_id
  attr_reader :cipher_suites
  attr_reader :maximum_name_length
  attr_reader :extensions

  # @param public_name [String]
  # @param public_key [HpkePublicKey]
  # @param kem_id [HkpeKemId]
  # @param cipher_suites [Array of HpkeCipherSuite]
  # @param maximum_name_length [Integer]
  # @param extensions [Array of Extension]
  # rubocop: disable Metrics/ParameterLists
  def initialize(public_name,
                 public_key,
                 kem_id,
                 cipher_suites,
                 maximum_name_length,
                 extensions)
    @public_name = public_name
    @public_key = public_key
    @kem_id = kem_id
    @cipher_suites = cipher_suites
    @maximum_name_length = maximum_name_length
    @extensions = extensions
  end
  # rubocop: enable Metrics/ParameterLists

  # @return [String]
  def encode
    @public_name.then { |s| [s.length].pack('n') + s } \
    + @public_key.encode \
    + @kem_id.encode \
    + @cipher_suites.map(&:encode).join.then { |s| [s.length].pack('n') + s } \
    + [@maximum_name_length].pack('n') \
    + @extensions.map(&:encode).join.then { |s| [s.length].pack('n') + s }
  end

  # :nodoc
  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/MethodLength
  # rubocop: disable Metrics/PerceivedComplexity
  def self.decode(octet)
    raise ::Resolv::DNS::DecodeError if octet.length < 2

    pn_len = octet.slice(0, 2).unpack1('n')
    i = 2
    raise ::Resolv::DNS::DecodeError if i + pn_len > octet.length

    public_name = octet.slice(i, pn_len)
    i += pn_len
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    pk_len = octet.slice(i, 2).unpack1('n')
    i += 2
    raise ::Resolv::DNS::DecodeError if i + pk_len > octet.length

    public_key = HpkePublicKey.decode(octet.slice(i, pk_len))
    i += pk_len
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    kem_id = HkpeKemId.decode(octet.slice(i, 2).unpack1('n'))
    i += 2
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    cs_len = octet.slice(i, 2).unpack1('n')
    i += 2
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    cipher_suites = HpkeCipherSuite.decode_vectors(octet.slice(i, cs_len))
    i += cs_len
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    maximum_name_length = octet.slice(i, 2).unpack1('n')
    i += 2
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    ex_len = octet.slice(i, 2).unpack1('n')
    i += 2
    raise ::Resolv::DNS::DecodeError if i + ex_len > octet.length

    extensions = Extensions.decode_vectors(octet.slice(i, ex_len))
    i += ex_len
    raise ::Resolv::DNS::DecodeError if i != octet.length

    new(
      public_name,
      public_key,
      kem_id,
      cipher_suites,
      maximum_name_length,
      extensions
    )
  end
  # rubocop: enable Metrics/AbcSize
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Metrics/PerceivedComplexity
end

# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Ech::ECHConfigContents
  # define class
end

Dir["#{File.dirname(__FILE__)}/echconfig_contents/*.rb"]
  .sort.each { |f| require f }

class SvcbRrPatch::SvcParams::Ech::ECHConfigContents
  attr_reader :key_config, :maximum_name_length, :public_name, :extensions

  # @param key_config [HpkeKeyConfig]
  # @param maximum_name_length [Integer]
  # @param public_name [String]
  # @param extensions [Array of Extension]
  def initialize(key_config,
                 maximum_name_length,
                 public_name,
                 extensions)
    @key_config = key_config
    @maximum_name_length = maximum_name_length
    @public_name = public_name
    @extensions = extensions
  end

  # @return [String]
  def encode
    @key_config.encode \
    + [@maximum_name_length].pack('C') \
    + @public_name.then { |s| [s.length].pack('C') + s } \
    + @extensions.map(&:encode).join.then { |s| [s.length].pack('n') + s }
  end

  # :nodoc
  def self.decode(octet)
    key_config, octet = HpkeKeyConfig.decode(octet)
    raise ::Resolv::DNS::DecodeError if octet.length < 2

    maximum_name_length = octet.slice(0, 1).unpack1('C')
    pn_len = octet.slice(1, 1).unpack1('C')
    i = 2
    raise ::Resolv::DNS::DecodeError if i + pn_len > octet.length

    public_name = octet.slice(i, pn_len)
    i += pn_len
    raise ::Resolv::DNS::DecodeError if i + 2 > octet.length

    ex_len = octet.slice(i, 2).unpack1('n')
    i += 2
    raise ::Resolv::DNS::DecodeError if i + ex_len > octet.length

    extensions = Extension.decode_vectors(octet.slice(i, ex_len))
    i += ex_len
    raise ::Resolv::DNS::DecodeError if i != octet.length

    new(
      key_config,
      maximum_name_length,
      public_name,
      extensions
    )
  end
end

# frozen_string_literal: true

class SvcbRrPatch::SvcParams::Echconfig::ECHConfigContents::HpkeCipherSuite
  # define class
end

Dir[File.dirname(__FILE__) + '/hpke_cipher_suite/*.rb']
  .sort.each { |f| require f }

class SvcbRrPatch::SvcParams::Echconfig::ECHConfigContents::HpkeCipherSuite
  attr_reader :kdf_id
  attr_reader :aead_id

  # @param kdf_id [HkpeKdfId]
  # @param aead_id [HkpeAeadId]
  def initialize(kdf_id, aead_id)
    @kdf_id = kdf_id
    @aead_id = aead_id
  end

  # @return [String]
  def encode
    @kdf_id.encode + @aead_id.encode
  end

  # @return [Array of HpkeCipherSuite]
  def self.decode_vectors(octet)
    i = 0
    cipher_suites = []
    while i < octet.length
      raise ::Resolv::DNS::DecodeError if i + 4 > octet.length

      kdf_id = HkpeKdfId.decode(octet.slice(i, 2))
      aead_id = HkpeAeadId.decode(octet.slice(i + 2, 2))
      i += 4
      cipher_suites << new(kdf_id, aead_id)
    end

    cipher_suites
  end
end

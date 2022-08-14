# frozen_string_literal: true

##
# The SVCB(contraction of "service binding") DNS Resource Record

class Resolv::DNS::Resource::IN::SVCB < Resolv::DNS::Resource
  TypeValue = 64 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  # @param svc_priority [Integer]
  # @param target_name [String]
  # @param svc_params [Hash]
  # rubocop: disable Lint/MissingSuper
  def initialize(svc_priority, target_name, svc_params)
    # https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-svcb-https-06
    @svc_priority = svc_priority
    @target_name = target_name
    @svc_params = svc_params
  end
  # rubocop: enable Lint/MissingSuper

  ##
  # SvcPriority

  attr_reader :svc_priority, :target_name, :svc_params

  ##
  # TargetName

  ##
  # SvcParams

  # :nodoc:
  def encode_rdata(msg)
    msg.put_bytes([@svc_priority].pack('n'))
    msg.put_string(@target_name)
    msg.put_string(@svc_params.encode)
  end

  class << self
    # :nodoc:
    def decode_rdata(msg)
      svc_priority = msg.get_bytes(2).unpack1('n')
      target_name = msg.get_string
      return new(svc_priority, target_name, {}) if svc_priority.zero?

      # the SvcParams, consuming the remainder of the record
      svc_params = ::SvcbRrPatch::SvcParams::Hash.decode(msg.get_bytes)
      new(svc_priority, target_name, svc_params)
    end
  end
end

# frozen_string_literal: true

##
# The SVCB(contraction of "service binding") DNS Resource Record

class Resolv::DNS::Resource::IN::SVCB < Resolv::DNS::Resource
  TypeValue = 64 # rubocop: disable Naming/ConstantName
  ClassValue = IN::ClassValue
  ClassHash[[TypeValue, ClassValue]] = self

  # @param svc_priority [Integer]
  # @param target_name [String]
  # @param svc_params [Map]
  def initialize(svc_priority, target_name, svc_params)
    # https://tools.ietf.org/html/draft-ietf-dnsop-svcb-https-01
    @svc_priority = svc_priority
    @target_name = target_name
    @svc_params = svc_params
  end

  ##
  # SvcPriority

  attr_reader :svc_priority

  ##
  # TargetName

  attr_reader :target_name

  ##
  # SvcParams

  attr_reader :svc_params

  # :nodoc:
  def encode_rdata(msg)
    msg.put_bytes([@svc_priority].pack('n1'))
    msg.put_string(@target_name)
    msg.put_string(::SvcbRrPatch::SvcParams.encode(@svc_params))
  end

  class << self
    # :nodoc:
    def decode_rdata(msg)
      svc_priority = msg.get_bytes(2).unpack1('n')
      target_name = msg.get_string
      return new(svc_priority, target_name, {}) if svc_priority.zero?

      # the SvcParams, consuming the remainder of the record
      svc_params = ::SvcbRrPatch::SvcParams.decode(msg.get_bytes)
      new(svc_priority, target_name, svc_params)
    end
  end
end

# frozen_string_literal: true

##
# The HTTPS DNS Resource Record

class Resolv::DNS::Resource::IN::HTTPS < Resolv::DNS::Resource::IN::SVCB
  TypeValue = 65 # rubocop: disable Naming/ConstantName
end

# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svcb_rr_patch/version'

Gem::Specification.new do |spec|
  spec.name          = 'svcb_rr_patch'
  spec.version       = SvcbRrPatch::VERSION
  spec.authors       = ['thekuwayama']
  spec.email         = ['thekuwayama@gmail.com']
  spec.summary       = 'the patch that adds SVCB Resource Record and HTTPS Resource Record'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/thekuwayama/svcb_rr_patch'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>=2.6.0'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
end

# svcb_rr_patch

[![Gem Version](https://badge.fury.io/rb/svcb_rr_patch.svg)](https://badge.fury.io/rb/svcb_rr_patch)
[![CI](https://github.com/thekuwayama/svcb_rr_patch/workflows/CI/badge.svg)](https://github.com/thekuwayama/svcb_rr_patch/actions?workflow=CI)
[![Maintainability](https://api.codeclimate.com/v1/badges/a1e5224a552014f2d4d5/maintainability)](https://codeclimate.com/github/thekuwayama/svcb_rr_patch/maintainability)

`svcb_rr_patch` is the patch that adds SVCB Resource Record and HTTPS Resource Record.

- https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-svcb-https-06

`svcb_rr_patch` supports "ech" SvcParamKey that ECHConfig.version is `0xfe0d`.

- https://datatracker.ietf.org/doc/html/draft-ietf-tls-esni-13#section-4


## Installation

he gem is available at [rubygems.org](https://rubygems.org/gems/svcb_rr_patch). You can install it the following.

```sh-session
$ gem install svcb_rr_patch
```


## Usage

You can resolve HTTPS resources.

```sh-session
$ irb
irb(main):001:0> require 'svcb_rr_patch'
=> true
irb(main):002:1* Resolv::DNS.new.getresources(
irb(main):003:1*   "blog.cloudflare.com",
irb(main):004:1*   Resolv::DNS::Resource::IN::HTTPS
irb(main):005:0> )
=>
[#<Resolv::DNS::Resource::IN::HTTPS:0x0000000000000001
  @svc_params=
   #<SvcbRrPatch::SvcParams::Hash:0x0000000000000002
    @hash=
     {"alpn"=>#<SvcbRrPatch::SvcParams::Alpn:0x0000000000000003 @protocols=["http/1.1", "h2"]>,
      "ipv4hint"=>#<SvcbRrPatch::SvcParams::Ipv4hint:0x0000000000000004 @addresses=[#<Resolv::IPv4 162.159.137.85>, #<Resolv::IPv4 162.159.138.85>]>,
      "ech"=>
       #<SvcbRrPatch::SvcParams::Ech:0x0000000000000005
        @echconfiglist=
         [#<SvcbRrPatch::SvcParams::Ech::ECHConfig:0x0000000000000006
           @echconfig_contents=
            #<SvcbRrPatch::SvcParams::Ech::ECHConfigContents:0x0000000000000007
             @extensions=[],
             @key_config=
              #<SvcbRrPatch::SvcParams::Ech::ECHConfigContents::HpkeKeyConfig:0x0000000000000008
               @cipher_suites=
                [#<SvcbRrPatch::SvcParams::Ech::ECHConfigContents::HpkeKeyConfig::HpkeSymmetricCipherSuite:0x0000000000000009
                  @aead_id=#<SvcbRrPatch::SvcParams::Ech::ECHConfigContents::HpkeKeyConfig::HpkeSymmetricCipherSuite::HpkeAeadId:0x0000000000000010 @uint16=1>,
                  @kdf_id=#<SvcbRrPatch::SvcParams::Ech::ECHConfigContents::HpkeKeyConfig::HpkeSymmetricCipherSuite::HpkeKdfId:0x0000000000000011 @uint16=1>>],
               @config_id=238,
               @kem_id=#<SvcbRrPatch::SvcParams::Ech::ECHConfigContents::HpkeKeyConfig::HpkeKemId:0x0000000000000012 @uint16=32>,
               @public_key=
                #<SvcbRrPatch::SvcParams::Ech::ECHConfigContents::HpkeKeyConfig::HpkePublicKey:0x0000000000000013
                 @opaque="I\x19\xD0\xCFP\b>e\xDF\xE1Q\xE8+i\x89\x8AJ\xA2b'\xD0j\xB9+\xDE\xE2\xDE\xF8\xFA\xAD\xBBm">>,
             @maximum_name_length=0,
             @public_name="cloudflare-esni.com">,
           @version="\xFE\r">]>,
      "ipv6hint"=>#<SvcbRrPatch::SvcParams::Ipv6hint:0x0000000000000014 @addresses=[#<Resolv::IPv6 2606:4700:7::a29f:8955>, #<Resolv::IPv6 2606:4700:7::a29f:8a55>]>}>,
  @svc_priority=1,
  @target_name="",
  @ttl=58>]
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

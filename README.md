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
   {"alpn"=>#<SvcbRrPatch::SvcParams::Alpn:0x0000000000000002 @protocols=["h2"]>,
    "ipv4hint"=>
     #<SvcbRrPatch::SvcParams::Ipv4hint:0x0000000000000003
      @addresses=[#<Resolv::IPv4 162.159.135.79>, #<Resolv::IPv4 162.159.136.79>]>,
    "ech"=>
     AEb+DQBCkQAgACADmRYszCFsGObsrlyNdNRa9ygTgcGruqQ9+D2INQZfCwAEAAEAAQATY2xvdWRmbGFyZS1lc25pLmNvbQAA,
    "ipv6hint"=>
     #<SvcbRrPatch::SvcParams::Ipv6hint:0x0000000000000004
      @addresses=[#<Resolv::IPv6 2606:4700:7::a29f:874f>, #<Resolv::IPv6 2606:4700:7::a29f:884f>]>},
  @svc_priority=1,
  @target_name="",
  @ttl=300>]
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

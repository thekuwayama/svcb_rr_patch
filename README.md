# svcb_rr_patch

[![Gem Version](https://badge.fury.io/rb/svcb_rr_patch.svg)](https://badge.fury.io/rb/svcb_rr_patch)
[![CI](https://github.com/thekuwayama/svcb_rr_patch/workflows/CI/badge.svg)](https://github.com/thekuwayama/svcb_rr_patch/actions?workflow=CI)
[![Maintainability](https://api.codeclimate.com/v1/badges/a1e5224a552014f2d4d5/maintainability)](https://codeclimate.com/github/thekuwayama/svcb_rr_patch/maintainability)

`svcb_rr_patch` is the patch that adds SVCB Resource Record and HTTPS Resource Record.

- https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-svcb-https-06

`svcb_rr_patch` supports "ech" SvcParamKey that ECHConfig.version is 0xfe0a.

- https://datatracker.ietf.org/doc/html/draft-ietf-tls-esni-10#section-4


## Installation

he gem is available at [rubygems.org](https://rubygems.org/gems/svcb_rr_patch). You can install it the following.

```bash
$ gem install svcb_rr_patch
```


## Usage

You can resolve HTTPS resources.

```bash
$ irb
irb(main):001:0> require 'svcb_rr_patch'
=> true
irb(main):002:1* Resolv::DNS.new.getresources(
irb(main):003:1*   "blog.cloudflare.com",
irb(main):004:1*   Resolv::DNS::Resource::IN::HTTPS
irb(main):005:0> )
=> [#<Resolv::DNS::Resource::IN::HTTPS:0x0000000000000001 @svc_priority=1, @svc_domain_name="", @svc_field_value={"alpn"=>#<SvcbRrPatch::SvcParams::Alpn:0x0000000000000002 @protocols=["h3-29", "h3-28", "h3-27", "h2"]>, "ipv4hint"=>#<SvcbRrPatch::SvcParams::Ipv4hint:0x0000000000000003 @addresses=[#<Resolv::IPv4 104.18.26.46>, #<Resolv::IPv4 104.18.27.46>]>, "ipv6hint"=>#<SvcbRrPatch::SvcParams::Ipv6hint:0x0000000000000004 @addresses=[#<Resolv::IPv6 2606:4700::6812:1a2e>, #<Resolv::IPv6 2606:4700::6812:1b2e>]>}, @ttl=300>]
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

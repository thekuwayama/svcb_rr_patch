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

```ruby
$ irb
irb(main):001:0> require 'svcb_rr_patch'
=> true
irb(main):002:1* rr = Resolv::DNS.new.getresources(
irb(main):003:1*   "crypto.cloudflare.com",
irb(main):004:1*   Resolv::DNS::Resource::IN::HTTPS
irb(main):005:0> )
=>
[#<Resolv::DNS::Resource::IN::HTTPS:0x0000000000000000
...
irb(main):006:0> rr.first.svc_params.to_s
=> "alpn=http/1.1,h2 ipv4hint=162.159.137.85,162.159.138.85 ech=AEb+DQBC4wAgACCaqAJAAhqN4e1k2RSa+rFgJCpJNOapZy5FdQZUN5ITXAAEAAEAAQATY2xvdWRmbGFyZS1lc25pLmNvbQAA ipv6hint=2606:4700:7::a29f:8955,2606:4700:7::a29f:8a55"
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

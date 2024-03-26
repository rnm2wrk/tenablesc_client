TenableSC Client
=========

Usable, fast, simple Ruby gem for Tenable Security Center v6.2.1
TenableSCClient was designed to be simple, fast and performant through communication with Tenable SC over REST interface.

**Ruby gem for Tenable SC API**

  * [Source Code](https://github.com/rnm2wrk/tenablesc_client)

## Contact

*Code and Bug Reports*

* [Issue Tracker](https://github.com/rnm2wrk/tenablesc_client/issues)
* See [CONTRIBUTING](https://github.com/rnm2wrk/tenablesc_client/blob/master/CONTRIBUTING.md) for how to contribute along with some common problems to check out before creating an issue.


Getting started
---------------

```ruby
require 'tenablesc_client'

tc = TenablescClient.new(
  {
    uri: 'https://localhost:1443/',
    ssl_verify_peer: false,
    access_key: 'access_key',
    secret_key: 'secret_key'
  }
)
if tc.check_session
  puts tc.get_vulns_by_query_name('query_name')
end

tc2 = TenablescClient.new(
  {
    uri: 'https://localhost:1443/',
    ssl_verify_peer: false,
    username: 'username',
    password: 'password'
  }
)

if tc2.check_session
  puts tc.get_vulns_by_query_name('query_name')
end
```

## Requirements

Requirements are Exon for HTTP(S) and Oj parsing:

```ruby
require 'excon'
require 'oj'
```

## Code of Conduct

Everyone participating in this project's development, issue trackers and other channels is expected to follow our
[Code of Conduct](./CODE_OF_CONDUCT.md).

## Contributing

See the [contributing guide](./CONTRIBUTING.md).

## Copyright

Copyright (c) 2024 Rafael Machado. See MIT-LICENSE for details.

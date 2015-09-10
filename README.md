# nsd

[![Build Status](https://travis-ci.org/mfinelli/puppet-nsd.svg?branch=master)](https://travis-ci.org/mfinelli/puppet-nsd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nsd](#setup)
    * [What nsd affects](#what-nsd-affects)
    * [Beginning with nsd](#beginning-with-nsd)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Manage the installation and configuration of NSD (name serve daemon) and zone
files.

## Module Description

This module allows for the management of all aspects of the NSD configuration
file, keys and zonefiles. It adds easy slave/master configuration but you can
also use the module to create authoritative zonefiles and essentially have
puppet become the master nameserver and all nameservers would be the slaves.

The module only writes non-default options to the configuration file and allows
you to set any option through the use of hashes instead of predefined variables,
where appropriate.

## Setup

### What nsd affects

* Only non-default configuration options are written to `etc/nsd/nsd.conf`.
* Also manages the nsd package and service (unless `service_manage = false`).

### Beginning with nsd

Install the package an make sure it is enabled and running with default options:

```puppet
include '::nsd'
```

With some basic configuration:

```puppet
class { '::nsd':
  options => {
    'server-count' => 1,
    'ip-address'   => ['1.2.3.4', '5.6.7.8'],
  }
}
```

## Usage


The bare miniumum will make sure the nsd package is installed and the service is
running:

```puppet
include '::nsd'
```

To pass ins some configuration options:

```puppet
class { '::nsd':
  options => {
    'server-count' => 1,
    'ip-address'   => ['1.2.3.4', '5.6.7.8'],
  }
}
```

To configure the remote with defaults:

```puppet
include '::nsd::remote'
```

To set configuration options where puppet *does not* manage files:

```puppet
class { '::nsd::remote':
  port            => 8953,
  server_key_file => '/etc/nsd/arbitrary_filename.key',
}
```

To have puppet manage the keys and certificate files:

```puppet
class { '::nsd::remote':
  server_key_manage  => true,
  server_key_file    => 'puppet:///modules/nsd/nsd_server.key'
  server_cert_manage => true,
  server_cert_file   => 'puppet:///modules/nsd/nsd_server.pem'
}
```

To setup transfer keys:

```puppet
::nsd::key { 'testkey':
  secret => 'INhFh7DsZRRXp2NX/0vB+nS7Nh+lOfBJnpQgVmXllVs='
}
```

To create an arbitrary pattern:

```puppet
::nsd::pattern { 'testpattern':
  options => {
    'notify-retry' => 5,
  }
}
```

To create a master pattern: (note that the `slave_key` is just the key name and
that setting options is completely optional)

```puppet
::nsd::pattern::master { 'master':
  slave_server => '127.0.0.1',
  slave_key    => 'testkey',
  options      => {
    'notify-retry' => 5,
  }
}
```

Now the pattern can be included in zones by the name "to_slave_127.0.0.1".

To create a slave pattern: (note that the `master_key` is just the key name)

```puppet
::nsd::pattern::slave { 'slave':
  master_server => '127.0.0.1',
  master_key    => 'testkey',
}
```

Now the pattern can be included in zones by the name "from_master_127.0.0.1".

To create a zone with a file managed by puppet and using the slave pattern from
above:

```puppet
::nsd::zone { 'example.com':
  zonefile_manage => true,
  zonefile        => 'puppet:///modules/nsd/example.com.zone',
  options         => {
    'include-pattern' => 'from_master_127.0.0.1'
  }
}
```

To create an authoritative zone and include it in the main configuration file
with the master pattern from above:

```puppet
::nsd::zonefile { 'example.org':
  serial_number => 2015050101,
  admin_email   => 'admin@example.org',
  nameservers   => ['ns1.example.org.', 'ns2.example.org.'],
  mxservers     => {5 => 'mail1.example.org.', 10 => 'mail2.example.org.'},
  records       => [
    {'name' => 'ns1', 'type' => 'A', 'location' => '127.0.0.1'},
    {'name' => 'ns2', 'type' => 'A', 'location' => '127.0.0.2'},
    {'name' => '@', 'type' => 'A', 'location' => '123.123.123.123'},
    {'name' => 'www', 'type' => 'CNAME', 'location' => '@'},
  ],
  'include-options' => {
    'include-pattern' => 'to_slave_127.0.0.1',
  },
}
```

This would result in the following authoritative zone for example.org saved in
`etc/nsd/example.org.zone`:

```
;; example.org authoritative zone managed by puppet

$ORIGIN example.org.
$TTL 86400

@ IN SOA ns1.example.org. admin.example.org. ( 2015050101 28800 7200 864000 86400 )

 NS ns1.example.org.
 NS ns2.example.org.

 MX 5 mail1.example.org.
 MX 10 mail2.example.org.

 ns1 A 127.0.0.1
 ns2 A 127.0.0.2
 @ A 123.123.123.123
 www CNAME @
```

## Reference

### Classes

#### Public classes

* nsd: main class, includes all other private classes
* nsd::remote: enables and configures the remote

#### Private classes

* nsd::install: Handles the packages.
* nsd::config: Handles the configuration file.
* nsd::service: Handles the service.

### Defined types

* nsd::key: creates transfer keys.
* nsd::pattern: creates pattern sections.
* nsd::pattern::master: a macro for the nsd::pattern type to ease creation of
  master servers.
* nsd::pattern::slave: a macro for the nsd::pattern type to ease creation of
  slave servers.
* nsd::zone: adds zones and zonefiles.
* nsd::zonefile: creates authoritative zonefiles.

### Parameters: `nsd`

The following parameters are available in the nsd module:

#### `config`

This is the filename of the main configuration file. Default value:
'/etc/nsd/nsd.conf'

#### `config_template`

The template to use for the server section of the configuration file. Default
value: 'nsd/nsd.conf.erb'

#### `options`

Hash of options to set in the configuration file under the `server` section.

```puppet
$options = {
  'option'       => 'value',
  'other_option' => ['value1', 'value2']
}
```

#### `package_ensure`

Tells Puppet whether the NSD package should be installed, and what version.
Valid options: 'present', 'latest', or a specific version number. Default value:
'present'

#### `package_name`

Tells Puppet what NSD package to manage. Valid options: string. Default value:
'nsd'

#### `service_manage`

Tells Puppet whether to manage the NSD service. Valid options: 'true' or
'false'. Default value: 'true'

#### `service_ensure`

Tells Puppet whether the NSD service should be running. Valid options: 'running'
or 'stopped'. Default value: 'running'

#### `service_enable`

Tells Puppet whether to enable the NSD service at boot. Valid options: 'true' or
'false'. Default value: 'true'

#### `service_name`

Tells Puppet what NSD service to manage. Valid options: string. Default value:
'nsd'

### Parameters: `nsd::remote`

The following parameters are available in the nsd::remote module:

#### `config`

The config file to write the remote section. Inherits from nsd::params::config,
so if you overwrite there you'll need to overwrite here as well.

#### `config_template`

The template to use for writing the remote section. Default value:
'nsd/remote.erb'

#### `enable`

Whether to enable the remote or not. Default value is true but it should never
be necessary to set it to false, in that case just don't include the nsd::remote
module and nothing will be written to the configuration file.

#### `interface`

Either a string or an array of strings of interfaces that ar listened to for
control. Defaults to localhost.

#### `port`

Port number for remote control operations (uses TLS over TCP). Default value:
8952

#### `server_key_manage`

Whether to have puppet manage the server key file. Default value: false

#### `server_key_file`

If `server_key_manage` is true then this points to a source for the file.
Otherwise it can be undefined or an arbitrary filename for server-key-file.

#### `server_cert_manage`

Whether to have puppet manage the server cert file. Default value: false

#### `server_cert_file`

If `server_cert_manage` is true then this points to a source for the file.
Otherwise it can be undefined or an arbitrary filename for server-cert-file.

#### `control_key_manage`

Whether to have puppet manage the control key file. Default value: false

#### `control_key_file`

If `control_key_manage` is true then this points to a source for the file.
Otherwise it can be undefined or an arbitrary filename for control-key-file.

#### `control_cert_manage`

Whether to have puppet manage the control cert file. Default value: false

#### `control_cert_file`

If `control_cert_manage` is true then this points to a source for the file.
Otherwise it can be undefined or an arbitrary filename for control-cert-file.

### Parameters: `nsd::key`

The following parameters are available in the nsd::key defined type:

#### `config`

The config file to write the key section. Inherits from nsd::params::config, so
if you overwrite there you'll need to overwrite here as well.

#### `config_template`

The template to use for writing the key section. Default value: 'nsd/key.erb'

#### `algorithm`

Algorithm to use. Valid options: 'md5', 'sha1', 'sha256'. Defaul value: 'sha256'

#### `secret`

The secret material to use. Recommended to generate with the command:
`dd if=/dev/random of=/dev/stdout count=1 bs=32 | base64`.

#### `secret_file`

Whether the secret should be stored in a separate file with 640 permissions.
Defaults to false. If true the filename will be `name.keyfile`.

### Parameters `nsd::pattern`

The following parameters are available in the nsd::pattern defined type:

#### `config`

The config file to write the pattern section. Inherits from nsd::params::config,
so if you overwrite there you'll need to overwrite here as well.

#### `config_template`

The template to use for writing the pattern section. Default value:
'nsd/pattern.erb'

#### `options`

Hash of options to set for the pattern.

```puppet
$options = {
  'option' => 'value',
}
```

### Parameters `nsd::pattern::master`

The following paramters are available in the nsd::pattern::master defined type:

#### `slave_server`

The server that needs to be notified when zone files change.

#### `slave_key`

The name of the TSIG key with which to perform the transfer.

#### `options`

Any additional valid pattern options to set.

### Parameters `nsd::pattern::slave`

The following parameters are available in the nsd::pattern::slave defined type:

#### `master_server`

The server to allow zone transfers from.

#### `master_key`

The name of the TSIG key with which to perform the transfer.

#### `transfer_mode`

The transfer mode. Since NSD only speaks AXFR you shouldn't ever need to change
it, but depending on your other servers you might want something like IXFR/UDP.

#### `options`

Any additional valid pattern options to set.

### Parameters `nsd::zone`

The following parameters are available in the nsd::zone defined type:

#### `config`

The config file to write the zone section. Inherits from nsd::params::config, so
if you overwrite there you'll need to overwrite here as well.

#### `config_template`

The template to use for writing the zone section. Default value: 'nsd/zone.erb'

#### `zonefile_manage`

Whether to have puppet manage the zonefile. Default value: false

#### `zonefile`

If `zonefile_manage` is true then this should be a path to a file that puppet
can serve. Otherwise it will enter the arbitrary name here as the zonefile value
in nsd.conf.

#### `options`

Any additional valid zone options to set (e.g., "include-pattern").

### Parameters `nsd::zonefile`

The following parameters are available in the nsd::zonefile defined type:

#### `include_in_config`

Whether or not to include the zone in `nsd.conf`. Default value: true

#### `include_options`

Any additional valid zone options to set when including the zone in `nsd.conf`
(e.g., "include-pattern").

#### `serial_number`

The serial number for the zone. Can be any valid integer but usually we use the
form 'YYYYMMDDnn'.

#### `admin_email`

The admin email address for the zone. Should *not* have a period at the end, it
will be automatically added in the template.

#### `ttl`

Value in seconds of the time to live. Should be less than three days. Default
value: 86400 (1 day)

#### `refresh`

Value in seconds that a slave will try to refresh the zone. Recommended setting
is between one hour and one day depending on how often your zone changes.
Default value: 28800 (8 hours)

#### `retry`

Value in seconds that a slave will wait before retrying if they are unable to
connect to the master. Recommended value is between five minutes and four hours.
Default value: 7200 (2 hours)

#### `expire`

Value in seconds that the zone is valid for. Recommended value is between one
week and four weeks. Default value is 864000 (10 days)

#### `nameservers`

An array of nameservers for this domain. N.B. that they need to end in a period.

#### `mxservers`

A hash of the mail servers for the domain. The priority is the key and the
server is the value. The are automatically ordered. N.B. that the servers need
to end in a period.

#### `records`

An array of hashes of the records that the zone should serve. Each hash needs to
have three keys: name, type, and location.

### Functions

This module defines several custom functions in order to validate data.

#### `validate_ip_address_array`

Validates an array of IP addresses, raising a ParseError should one or more
addresses fail. Validates both v4 and v6 IP addresses.

##### Examples

The following values will pass:

```puppet
validate_ip_address_array(['127.0.0.1', '::1'])
```

The following values will raise an error:

```puppet
validate_ip_address_array('127.0.0.1')
validate_ip_address_array(['not-an-address'])
```

## Limitations

This module has been tested on:

* Debian 8 (jessie)

## Development

This module is still under development. If you would like to help (especially
for platforms other than Debian) please send fork the project at
[GitHub](https://github.com/mfinelli/puppet-nsd) and send a pull request. New
features belong in a feature branch named `feature/your-feature` and the pull
request should be against the
[develop](https://github.com/mfinelli/puppet-nsd/tree/develop) branch. Please
add your name below and to the authors section of any file that you modify.
While not required, it would be nice if you wrote test cases for any
functionality that you add.

## Authors

* Mario Finelli

## License

Copyright 2015 Mario Finelli

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

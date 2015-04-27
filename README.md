# nsd

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

This module is still under development, but it will be possible to configure
all aspects of NSD including zone files and master/slave configurations.

So far it is possible to configure the nsd server and remote.

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

## Reference

### Classes

#### Public classes

* nsd: main class, includes all other private classes
* nsd::remote: enables and configures the remote

#### Private classes

* nsd::install: Handles the packages.
* nsd::config: Handles the configuration file.
* nsd::service: Handles the service.

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

#### `service_enable`

Tells Puppet whether to enable the NSD service at boot. Valid options: 'true' or
'false'. Default value: 'true'

#### `service_ensure`

Tells Puppet whether the NSD service should be running. Valid options: 'running'
or 'stopped'. Default value: 'running'

#### `service_manage`

Tells Puppet whether to manage the NSD service. Valid options: 'true' or
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

## Limitations

This module has been tested on:

* Debian 8 (jessie)

## Development

This module is still under development. If you would like to help (especially
for platforms other than Debian) please send fork the project at
[GitHub](https://github.com/mfinelli/puppet-nsd) and send a pull request. New
features belong in a feature branch named `feature/your-feature` and the pull
request should be against the
[develop](https://github.com/mfinelli/puppet-nsd/tree/develop) branch.

## Authors

* Mario Finelli
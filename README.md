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
all aspects of NSD including remote, zone files and master/slave configurations.

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

## Reference

### Classes

#### Public classes

* nsd: main class, includes all other classes

#### Private classes

* nsd::install: Handles the packages.
* nsd::config: Handles the configuration file.
* nsd::service: Handles the service.

### Parameters

The following parameters are available in the nsd module:

#### `options`

Hash of options to set in the configuration file under the `server` section.

```puppet
$options = {
  'option'       => 'value',
  'other_option' => ['value1', 'value2']
}
```

#### `package_ensure`

Tells Puppet whether the NSD package should be installed, and what version. Valid options: 'present', 'latest', or a
specific version number. Default value: 'present'

#### `package_name`

Tells Puppet what NSD package to manage. Valid options: string. Default value: 'nsd'

#### `service_enable`

Tells Puppet whether to enable the NSD service at boot. Valid options: 'true' or 'false'. Default value: 'true'

#### `service_ensure`

Tells Puppet whether the NSD service should be running. Valid options: 'running' or 'stopped'. Default value: 'running'

#### `service_manage`

Tells Puppet whether to manage the NSD service. Valid options: 'true' or 'false'. Default value: 'true'

#### `service_name`

Tells Puppet what NSD service to manage. Valid options: string. Default value: 'nsd'

## Limitations

This module has been tested on:

* Debian 8 (jessie)

## Development

This module is still under development. If you would like to help (especially for platforms other
than Debian) please send a pull request at [GitHub](https://github.com/mfinelli/puppet-nsd).

## Authors

* Mario Finelli
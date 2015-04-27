# Change Log

This file keeps track of notable changes to the NSD puppet module. Like all
[puppet modules](https://forge.puppetlabs.com) it adheres to
[semantic versioning](http://semver.org).

## [0.2.0] 2015-04-27

This release adds configuration and management of the nsd remote.

### Additions

* New `nsd::remote` class which allows management of the remote section of
  nsd.conf and related certificates and keys.

### Changes

* Depend on the concat module so we can split the nsd.conf into separate
  classes.
* Remove remote control section from main file as it's now in its own fragment.

## [0.1.0] 2015-04-26

Initial release.
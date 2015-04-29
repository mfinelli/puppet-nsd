# Change Log

This file keeps track of notable changes to the NSD puppet module. Like all
[puppet modules](https://forge.puppetlabs.com) it adheres to
[semantic versioning](http://semver.org).

## [0.3.0] 2015-04-28

This release adds configuration and management of keys and patterns.

### Additions

* New `nsd::key` defined type which allows the creation of keys either directly
  in the configuration file or as separate files to be included in it.
* New `nsd::pattern` defined type whi can create patterns. This type will be
  extended to allow easy creation of slave/master setup, but it is also
  possible to create arbitrary patterns using the `options` parameter.

### Changes

* Force root ownership of key and certificate files if puppet manages them.

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

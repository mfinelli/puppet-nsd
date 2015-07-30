# Change Log

This file keeps track of notable changes to the NSD puppet module. Like all
[puppet modules](https://forge.puppetlabs.com) it adheres to
[semantic versioning](http://semver.org).

## [0.6.0] - 2015-07-29

This release adds more tests and validations for manifests.

### Additions

* New validation function for zonefile nameservers to ensure that all of them
  end in a full stop.
* Puppet 4.2 in the testing matrix!

### Changes

* Updates to zonefiles now trigger the nsd service to refresh

## [0.5.6] 2015-07-12

This release is a hotfix to remove leading spaces from zonefile records.

## [0.5.5] 2015-05-24

This release is a hotfix to the puppet requirements in the metadata.

## [0.5.4] 2015-05-24

This release adds initial acceptance testing with beaker and rspec tests for
nsd remote. It also adds Ubuntu 14.04 to the list of supported operating
systems.

### Additions

* Rspec tests for `nsd::remote`.
* Custom function to validate an array of IP addresses.
* Acceptance tests for `nsd::remote`

## [0.5.3] 2015-05-18

This release adds tests for zonefiles.

### Additions

* Rspec tests for zonefiles.
* Add validations for zonefiles - try to help write zonefiles by enforcing
  certain restrictions on the values that can be used.

## [0.5.2] 2015-05-14

This release adds rspec tests.

### Changes

* Update Rakefile and add rspec options for [travis](https://travis-ci.org)
  continuous integration builds.
* Fix all lint issues (mostly top-scope warnings).

## [0.5.1] 2015-05-13

This release adds real documentation to all manifest files.

### Additions

* Description, parameters, examples, and license to manifests: init, config,
  install, params, service, remote, key, pattern, master pattern, slave
  pattern, zone, and zonefile.
* Add author list and license to all of the template files.

## [0.5.0] 2015-05-01

This release adds the ability to add zones to the configuration file and to
create authoritative zonefiles.

### Additions

* New `nsd::zone` defined type to add zones to the main configuration file. It
  supports arbitrary zonefile paths or you can optionally specify the path to a
  file and have puppet manage it as well.
* New `nsd::zonefile` to create authoritative zones. By default it will also
  add the zone into nsd.conf.

## [0.4.0] 2015-04-29

This release adds in slave and master patters which are essentially just macros
for the existing pattern definition.

### Additions

* New `nsd::pattern::master` defined type which is just an existing
  `nsd::pattern` but with options `notify` and `provide-xfr` enforced.
* New `nsd::pattern::slave` defined type which is just an existing
  `nsd::pattern` but with the options `allow-notify` and `request-xfr` enforced
  with an optional parameter to change the transfer mode.

## [0.3.0] 2015-04-28

This release adds configuration and management of keys and patterns.

### Additions

* New `nsd::key` defined type which allows the creation of keys either directly
  in the configuration file or as separate files to be included in it.
* New `nsd::pattern` defined type which can create patterns. This type will be
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

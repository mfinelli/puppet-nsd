# == Class: nsd
#
# Full description of class nsd here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'nsd':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Mario Finelli <mario@finel.li>
#
# === Copyright
#
# Copyright 2015 Mario Finelli, unless otherwise noted.
#
class nsd (
  $package_name    = $nsd::params::package_name,
  $package_ensure  = $nsd::params::package_ensure,
  $service_enable  = $nsd::params::service_enable,
  $service_name    = $nsd::params::service_name,
  $service_ensure  = $nsd::params::service_ensure,
  $service_manage  = $nsd::params::service_manage,
  $config          = $nsd::params::config,
  $config_template = $nsd::params::config_template,
  $options         = {},
) inherits nsd::params {
  anchor { 'nsd::start': } ->
    class { '::nsd::install': } ->
    class { '::nsd::config': } ~>
    class { '::nsd::service': } ->
  anchor { 'nsd::end': }
}

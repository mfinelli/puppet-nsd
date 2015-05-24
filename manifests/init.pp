# == Class: nsd
#
# This is the main nsd class. It includes all of the private classes and allows
# for the basic configuration of the "server" section of the nsd.conf file.
#
# === Parameters
#
# [*config*]
#   This is the filename of the main configuration file. Its value is inherited
#   from the nsd::params class, unless overridden here.
#   Default value: '/etc/nsd/nsd.conf'
#
# [*config_template*]
#   The template to use for the server section of the configuration file. Its
#   value is inherited from the nsd::params, unless overridden here.
#   Default value: 'nsd/nsd.conf.erb'
#
# [*options*]
#   Hash of options to set in the configuration file under the 'server'
#   section. The keys are the options and the values are their values. Valid
#   options are any of the valid options in the 'server' section of the main
#   configuration file.
#   Default value: {}
#
# [*package_ensure*]
#   Tells Puppet whether the NSD package should be installed, and what version.
#   Inherits from nsd::params, unless overridden here. Valid options are
#   'present', 'latest', or a specific version number.
#   Default value: 'present'
#
# [*package_name*]
#   Tells Puppet what NSD package to manage. Its value is inherited from
#   nsd::params unless overridden here.
#   Default value: 'nsd'
#
# [*service_manage*]
#   Tells Puppet whether to manage the NSD service. Inherits from nsd::params
#   unless overridden here. Valid options are true or false.
#   Default value: 'true'
#
# [*service_ensure*]
#   Tells Puppet whether the NSD service should be running. Inherits from
#   nsd::params unless overridden here. Valid options are 'running' or
#   'stopped'.
#   Default value: 'running'
#
# [*service_enable*]
#   Tells Puppet whether to enable the NSD service at boot. Inherits from
#   nsd::params unless overridden here. Valid options are true or false.
#   Default value: 'true'
#
# [*service_name*]
#   Tells Puppet what NSD service to manage. Inherits from nsd::params unless
#   overridden here.
#   Default value: 'nsd'
#
# === Examples
#
#  class { 'nsd':
#    options => {
#      'server-count' => 1,
#      'ip-address'   => ['1.2.3.4', '5.6.7.8'],
#    }
#  }
#
# === Authors
#
# Mario Finelli <mario@finel.li>
#
# === Copyright
#
# Copyright 2015 Mario Finelli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
  $options         = { },
) inherits nsd::params {
  anchor { 'nsd::start': } ->
    class { '::nsd::install': } ->
    class { '::nsd::config': } ~>
    class { '::nsd::service': } ->
  anchor { 'nsd::end': }

  # Remote files require that we have the directory first.
  file { '/etc/nsd/':
    ensure => 'directory',
    mode   => '0755',
    owner  => 0,
    group  => 0
  }
}

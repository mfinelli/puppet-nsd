# == Class: nsd::params
#
# Parameters for nsd. This is a private class that is inherited by other
# classes in order to provide default values.
#
# === Parameters
#
# [*config*]
#   This is the filename of the main configuration file.
#   Default value: '/etc/nsd/nsd.conf'
#
# [*config_template*]
#   The template to use for the server section of the configuration file.
#   Default value: 'nsd/nsd.conf.erb'
#
# [*package_ensure*]
#   Tells Puppet whether the NSD package should be installed, and what version.
#   Valid options are 'present', 'latest', or a specific version number.
#   Default value: 'present'
#
# [*package_name*]
#   Tells Puppet what NSD package to manage.
#   Default value: 'nsd'
#
# [*service_manage*]
#   Tells Puppet whether to manage the NSD service. Valid options are true or
#   false.
#   Default value: 'true'
#
# [*service_ensure*]
#   Tells Puppet whether the NSD service should be running. Valid options are
#   'running' or 'stopped'.
#   Default value: 'running'
#
# [*service_enable*]
#   Tells Puppet whether to enable the NSD service at boot. Valid options are
#   true or false.
#   Default value: 'true'
#
# [*service_name*]
#   Tells Puppet what NSD service to manage.
#   Default value: 'nsd'
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
class nsd::params {
  $package_name    = 'nsd'
  $package_ensure  = 'present'
  $service_enable  = true
  $service_name    = 'nsd'
  $service_ensure  = 'running'
  $service_manage  = true
  $config          = '/etc/nsd/nsd.conf'
  $config_template = 'nsd/nsd.conf.erb'
}

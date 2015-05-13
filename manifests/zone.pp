# == Define: nsd::zone
#
# This type creates a new zone in the configuration file optionally managing
# the actual zonefile (if you aren't creating zonefiles using nsd::zonefile).
#
# === Parameters
#
# [*config*]
#   The configuration file into which to write the zone section. It inherits
#   this value from nsd::params::config.
#   Default value: '/etc/nsd/nsd.conf'
#
# [*config_template*]
#   The template to use for writing the zone section.
#   Default value: 'nsd/zone.erb'
#
# [*zonefile_manage*]
#   If you aren't using nsd::zonefile for this zone and you want Puppet to
#   manage the actual zonefile then you should set this to true. Valid options
#   are true and false.
#   Default value: false
#
# [*zonefile*]
#   If zonefile_manage is true then this should be the path to a file that
#   Puppet can serve. Otherwise, it will enter the arbitrary name here as the
#   zonefile value in the configuration file. This parameter is required.
#   Default value: undefined
#
# [*options*]
#   Hash of options to set for this zone. You can set any valid option here by
#   using the key as the name of the option and the value as its value.
#   Default value: {}
#
# === Examples
#
#  nsd::zone { 'example.com':
#    zonefile_manage => true,
#    zonefile        => 'puppet:///modules/nsd/example.com.zone',
#    options         => {
#      'include-pattern' => 'from_master_127.0.0.1'
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
define nsd::zone (
  $config          = undef,
  $config_template = 'nsd/zone.erb',
  $zonefile_manage = false,
  $zonefile        = undef,
  $options         = {},
) {
  if $config == undef {
    include nsd::params
    $config_file = $nsd::params::config
  } else {
    $config_file = $config
  }

  if $zonefile_manage {
    $zonefile_path = "/etc/nsd/${name}.zone"
    file { $zonefile_path:
      ensure => present,
      mode   => '0644',
      owner  => 0,
      group  => 0,
      source => $zonefile,
      before => Concat::Fragment["nsd-zone-${name}"],
    }
  } else {
    $zonefile_path = $zonefile
  }

  concat::fragment { "nsd-zone-${name}":
    order   => '05',
    target  => $config_file,
    content => template($config_template),
  }
}

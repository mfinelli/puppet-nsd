# == Define: nsd::key
#
# This type creates a new key that can be used to transfer zonefiles.
#
# === Parameters
#
# [*config*]
#   The configuration file into which to write the key section. It inherits
#   this value from nsd::params::config.
#   Default value: '/etc/nsd/nsd.conf'
#
# [*config_template*]
#   The template to use for writing the key section.
#   Default value: 'nsd/key.erb'
#
# [*algorithm*]
#   Algorithm to use. Valid options are 'md5', 'sha1', and 'sha256'.
#   Default value: 'sha256'
#
# [*secret*]
#   The secret material to use. Recommended to generate with the command:
#   `dd if=/dev/random of=/dev/stdout count=1 bs=32 | base64`. This parameter
#   is required.
#   Default value: undefined
#
# [*secret_file*]
#   Whether or not to store the key in a separate file (owned by root with 640
#   permissions). If true then this file will be included in the main
#   configuration file and will be managed with puppet. In this case the
#   filename is 'name.keyfile'.
#   Default value: false
#
# === Examples
#
#  nsd::key { 'testkey':
#    secret => 'INhFh7DsZRRXp2NX/0vB+nS7Nh+lOfBJnpQgVmXllVs='
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
define nsd::key (
  $config          = undef,
  $config_template = 'nsd/key.erb',
  $algorithm       = 'sha256',
  $secret          = undef,
  $secret_file     = false,
) {
  if $secret == undef {
    fail('You must provide secret material.')
  } else {
    if $config == undef {
      include nsd::params
      $config_file = $nsd::params::config
    } else {
      $config_file = $config
    }

    $valid_algorithms = ['md5', 'sha1', 'sha256']

    if $algorithm in $valid_algorithms {
      if $secret_file {
        file { "/etc/nsd/${name}.keyfile":
          ensure  => present,
          mode    => '0640',
          owner   => 0,
          group   => 0,
          content => template($config_template),
        }
        ->
        concat::fragment { "nsd-keyfile-${name}":
          order   => '03',
          target  => $config_file,
          content => "include: \"/etc/nsd/${name}.keyfile\"\n\n",
        }
      } else {
        concat::fragment { "nsd-key-${name}":
          order   => '03',
          target  => $config_file,
          content => template($config_template),
        }
      }
    } else {
      fail('You have specified an invalid algorithm.')
    }
  }
}

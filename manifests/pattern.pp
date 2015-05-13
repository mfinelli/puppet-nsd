# == Define: nsd::pattern
#
# This type creates a new, arbitrary pattern that can be included with zone
# definitions. It is possible to set any valid pattern option using the options
# hash.
#
# === Parameters
#
# [*config*]
#   The configuration file into which to write the pattern section. It inherits
#   this value from nsd::params::config.
#   Default value: '/etc/nsd/nsd.conf'
#
# [*config_template*]
#   The template to use for writing the pattern section.
#   Default value: 'nsd/pattern.erb'
#
# [*options*]
#   Hash of options to set for this pattern. You can set any valid option here
#   by using the key as the name of the option and the value as its value.
#   Default value: {}
#
# === Examples
#
#  nsd::pattern { 'five_retry':
#    options => {
#      'notify-retry' => 5,
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
define nsd::pattern (
  $config          = undef,
  $config_template = 'nsd/pattern.erb',
  $options         = {}
) {
  if $config == undef {
    include nsd::params
    $config_file = $nsd::params::config
  } else {
    $config_file = $config
  }

  concat::fragment { "nsd-pattern-${name}":
    order   => '04',
    target  => $config_file,
    content => template($config_template),
  }
}

# == Define: nsd::pattern::master
#
# This creates a pattern that you can use for your master nameservers. It is
# really just a normal nsd::pattern with the notify and provide-xfr options
# required. Additionally, you can set any other valid option using the options
# hash.
#
# === Parameters
#
# [*slaver_server*]
#   The IP address of the server that needs to be notified when a zone file
#   changes. This parameter is required.
#   Default value: undefined
#
# [*slave_key*]
#   The name of the TSIG key with which to perform the zonefile transfer. This
#   parameter is required.
#   Default value: undefined
#
# [*options*]
#   Hash of additional options to set for this pattern. You can set any valid
#   option here by using the key as the name of the option and the value as its
#   value.
#   Default value: {}
#
# === Examples
#
#  nsd::pattern::master { 'master':
#    slave_server => '127.0.0.1',
#    slave_key    => 'testkey',
#    options      => {
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
define nsd::pattern::master (
  $slave_server = undef,
  $slave_key    = undef,
  $options      = {},
) {
  $notify = "${slave_server} ${slave_key}"
  $master_options = {
    'notify'      => $notify,
    'provide-xfr' => $notify,
  }

  $merged_options = merge($master_options, $options)
  ::nsd::pattern { "to_slave_${slave_server}":
    options => $merged_options,
  }
}

# == Define: nsd::pattern::slave
#
# This creates a pattern that you can use for your slave nameservers. It is
# really just a normal nsd::pattern with the allow-notify and request-xfr
# options required. Additionally, you can set any other valid option using the
# options hash.
#
# === Parameters
#
# [*master_server*]
#   The IP address of the server to allow zone transfers from. This parameter
#   is required.
#   Default value: undefined
#
# [*master_key*]
#   The name of the TSIG key with which to perform the zonefile transfer. This
#   parameter is required.
#   Default value: undefined
#
# [*transfer_mode*]
#   The transfer mode. Since NSD only speaks AXFR you shouldn't ever need to
#   change it, but depending on your other servers you might want something
#   like IXFR/UDP.
#   Default value: 'AXFR'
#
# [*options*]
#   Hash of additional options to set for this pattern. You can set any valid
#   option here by using the key as the name of the option and the value as its
#   value.
#   Default value: {}
#
# === Examples
#
#  nsd::pattern::slave { 'slave':
#    master_server => '127.0.0.1',
#    master_key    => 'testkey',
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
define nsd::pattern::slave (
  $master_server = undef,
  $transfer_mode = 'AXFR',
  $master_key    = undef,
  $options       = {},
) {
  $allow_notify = "${master_server} ${master_key}"
  $request_transfer = "${transfer_mode} ${allow_notify}"
  $slave_options = {
    'allow-notify' => $allow_notify,
    'request-xfr'  => $request_transfer,
  }

  $merged_options = merge($slave_options, $options)
  ::nsd::pattern { "from_master_${master_server}":
    options => $merged_options,
  }
}

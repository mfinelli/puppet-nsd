# == Class: nsd::config
#
# This class is actually responsible for configuring nsd. It includes the
# options from the main nsd class and adds them as the first fragment in the
# final configuration file.
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
class nsd::config inherits nsd {
  concat { $config:
    ensure => present,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  concat::fragment { 'nsd-server':
    order   => '01',
    target  => $config,
    content => template($config_template),
  }
}

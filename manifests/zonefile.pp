# == Define: nsd::zonefile
#
# Use this type to create an authoritative zonefile for a domain.
#
# === Parameters
#
# [*include_in_config*]
#   Whether or not to create a zone entry in the main configuration file. Valid
#   options are true and false.
#   Default value: true
#
# [*include_options*]
#   Any additional valid zone options to set when including the zone entry in
#   the configuration file. This is just like nsd::zone::options so you might
#   include e.g., "include-pattern".
#   Default value: {}
#
# [*serial_number*]
#   The serial number for the zone. Can be any valid integer but usually we use
#   the form 'YYYYMMDDnn'. This parameter is required.
#   Default value: undefined
#
# [*admin_email*]
#   The admin email address for the zone. Should *not* have a period at the
#   end as it will be automatically added in the template. An example value
#   would be: "admin@example.com". This parameter is required.
#   Default value: undefined
#
# [*ttl*]
#   Value in seconds of the time to live. Should be less than three days.
#   Default value: 86400 (1 day)
#
# [*refresh*]
#   Value in seconds that a slave will try to refresh the zone. Recommended
#   setting is between one hour and one day depending on how often your zone
#   changes.
#   Default value: 28800 (8 hours)
#
# [*retry*]
#   Value in seconds that a slave will wait before retrying if they are unable
#   to connect to the master. Recommended value is between five minutes and
#   four hours.
#   Default value: 7200 (2 hours)
#
# [*expire*]
#   Value in seconds that the zone is valid for. Recommended value is between
#   one week and four weeks.
#   Default value is 864000 (10 days)
#
# [*nameservers*]
#   An array of nameservers for this domain. N.B. that they need to end in a
#   period. This parameter must be an array even for a single value. You must
#   include at least one server here.
#   Default value: []
#
# [*mxservers*]
#   A hash of the mail servers for the domain. The priority is the key and the
#   server is the value. The are automatically ordered. N.B. that the servers
#   must end in a period.
#   Default value: {}
#
# [*records*]
#   An array of hashes of the records that the zone should serve. Each hash
#   needs to have three keys: name, type, and location. Refer to the examples
#   section or README.md for exact usage.
#   Default value: {}
#
# === Examples
#
# Refer to README.md for the resulting zonefile:
#   nsd::zonefile { 'example.org':
#     serial_number => 2015050101,
#     admin_email   => 'admin@example.org',
#     nameservers   => ['ns1.example.org.', 'ns2.example.org.'],
#     mxservers     => {5 => 'mail1.example.org.', 10 => 'mail2.example.org.'},
#     records       => [
#       {'name' => 'ns1', 'type' => 'A', 'location' => '127.0.0.1'},
#       {'name' => 'ns2', 'type' => 'A', 'location' => '127.0.0.2'},
#       {'name' => '@', 'type' => 'A', 'location' => '123.123.123.123'},
#       {'name' => 'www', 'type' => 'CNAME' 'location' => '@'},
#     ],
#     'include-options' => {
#       'include-pattern' => 'to_slave_127.0.0.1'
#     },
#   }
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
define nsd::zonefile (
  $include_in_config = true,
  $include_options   = {},
  $serial_number     = undef,
  $ttl               = 86400,
  $refresh           = 28800,
  $retry             = 7200,
  $expire            = 864000,
  $nameservers       = [],
  $mxservers         = {},
  $records           = [],
  $admin_email       = undef,
) {
  # Enforce required parameters.
  if $admin_email == undef {
    fail('You must provide an admin email address.')
  }
  if $serial_number == undef {
    fail('You must provide a serial number for this zone.')
  }

  # Fail if the admin email address ends in a full stop -- we do that.
  if $admin_email =~ /\.$/ {
    fail('The admin email address shouldn\'t end in a full stop.')
  }

  # Now fail a full email validation. If we did this first an unsuspecting user
  # might not realize that the only error was a full stop in an otherwise valid
  # email address.
  unless $admin_email =~ /^[A-Za-z0-9]+@[a-z0-9]+\.[a-z]+$/ {
    fail('Admin email address is invalid.')
  }

  # Make sure that nameservers is an array with at least one entry and all
  # values ending with a full stop.
  validate_array($nameservers)
  unless $nameservers.count >= 1 {
    fail('You must specify at least one nameserver.')
  }
  $nameservers.each |String $nameserver| {
    unless $nameserver =~ /\.$/ {
      fail('All nameservers must end in a full stop.')
    }
  }

  # Make sure that all of our time variables are positive integers.
  validate_integer($ttl)
  validate_integer($refresh)
  validate_integer($retry)
  validate_integer($expire)

  # validate_integer allows arrays of Integers which we aren't interested in.
  unless $ttl =~ Integer {
    fail('Time to live must be an integer.')
  }
  if $ttl < 0 {
    fail('Time to live must be positive.')
  }
  unless $refresh =~ Integer {
    fail('Refresh value must be an integer.')
  }
  if $refresh < 0 {
    fail('Refresh value must be positive.')
  }
  unless $retry =~ Integer {
    fail('Retry value must be an integer.')
  }
  if $retry < 0 {
    fail('Retry value must be positive.')
  }
  unless $expire =~ Integer {
    fail('Expire value must be an integer.')
  }
  if $expire < 0 {
    fail('Expire value must be positive.')
  }

  $zonefile_path = "/etc/nsd/${name}.zone"
  file { $zonefile_path:
    ensure  => present,
    mode    => '0644',
    owner   => 0,
    group   => 0,
    content => template('nsd/zonefile.erb'),
  }

  if $include_in_config {
    ::nsd::zone { $name:
      zonefile => $zonefile_path,
      options  => $include_options,
    }
  }
}

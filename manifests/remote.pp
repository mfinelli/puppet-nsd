# == Class: nsd::remote
#
# This class configures the nsd remote.
#
# === Parameters
#
# [*config*]
#   The configuration file into which to write the remote section. It inherits
#   this value from nsd::params::config.
#   Default value: '/etc/nsd/nsd.conf'
#
# [*config_template*]
#   The template to use for writing the remote section.
#   Default value: 'nsd/remote.erb'
#
# [*enable*]
#   Whether to enable the remote or not. (N.B. that if you don't want the
#   remote enabled it's usually better to simply not include this class in your
#   manifest.) Valid options are true and false.
#   Default value: true
#
# [*interface*]
#   Which interfaces are listened to for control. Valid options are a string or
#   an array of strings.
#   Default value: localhost (127.0.0.1 and ::1)
#
# [*port*]
#   Port number for remote control operations (uses TLS over TCP).
#   Default value: 8952
#
# [*server_key_manage*]
#   Whether or not to have puppet manage the server key file. Valid options are
#   true and false.
#   Default value: false
#
# [*server_key_file*]
#   If server_key_manage is true then this should point to a source for the
#   file that puppet will manage. Otherwise, it can be undefined or an
#   arbitrary filename to use for the server-key-file. If undefined, then no
#   value will be written to the configuration file.
#   Default value: undefined
#
# [*server_cert_manage*]
#   Whether or not to have puppet manage the server certificate file. Valid
#   options are true and false.
#   Default value: false
#
# [*server_cert_file*]
#   If server_cert_manage is true then this should point to a source for the
#   file that puppet will manage. Otherwise, it can be undefined or an
#   arbitrary filename to use for the server-cert-file. If undefined, then no
#   value will be written to the configuration file.
#   Default value: undefined
#
# [*control_key_manage*]
#   Whether or not to have puppet manage the control key file. Valid options
#   are true and false.
#   Default value: false
#
# [*control_key_file*]
#   If control_key_manage is true then this should point to a source for the
#   file that puppet will manage. Otherwise, it can be undefined or an
#   arbitrary filename to use for the control-key-file. If undefined, then no
#   value will be written to the configuration file.
#   Default value: undefined
#
# [*control_cert_manage*]
#   Whether or not to have puppet manage the control certificate file. Valid
#   options are true and false.
#   Default value: false
#
# [*control_cert_file*]
#   If control_cert_manage is true then this should point to a source for the
#   file that puppet will manage. Otherwise, it can be undefined or an
#   arbitrary filename to use for the control-cert-file. If undefined, then no
#   value will be written to the configuration file.
#   Default value: undefined
#
# === Examples
#
# Enable the remote with defaults:
#   include nsd::remote
#
# Use arbitrary filenames for key and certificate files:
#   class { 'nsd::remote':
#     server_key_file => '/etc/nsd/arbitrary_filename.key',
#   }
#
# Puppet will manage key and certificate files:
#   class { 'nsd::remote':
#     server_key_manage  => true,
#     server_key_file    => 'puppet:///modules/nsd/nsd_server.key'
#     server_cert_manage => true,
#     server_cert_file   => 'puppet:///modules/nsd/nsd_server.pem'
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
class nsd::remote (
  $config              = undef,
  $config_template     = 'nsd/remote.erb',
  $enable              = true,
  $interface           = ['127.0.0.1', '::1'],
  $port                = 8952,
  $server_key_manage   = false,
  $server_key_file     = undef,
  $server_cert_manage  = false,
  $server_cert_file    = undef,
  $control_key_manage  = false,
  $control_key_file    = undef,
  $control_cert_manage = false,
  $control_cert_file   = undef,
) {
  if $config == undef {
    include nsd::params
    $config_file = $nsd::params::config
  } else {
    $config_file = $config
  }

  if is_array($interface) {
    validate_ip_address_array($interface)
  } else {
    validate_ip_address_array([$interface])
  }

  validate_bool($enable)
  validate_integer($port)

  validate_bool($server_key_manage)
  validate_bool($server_cert_manage)
  validate_bool($control_key_manage)
  validate_bool($control_cert_manage)

  if $server_key_manage {
    if $server_key_file == undef {
      fail('You must specify a source to manage the server key.')
    } else {
      $server_key = '/etc/nsd/nsd_server.key'
      file { $server_key:
        ensure  => present,
        mode    => '0640',
        owner   => 0,
        group   => 0,
        source  => $server_key_file,
        require => File['/etc/nsd'],
        before  => Concat::Fragment['nsd-remote'],
      }
    }
  } else {
    $server_key = $server_key_file
  }

  if $server_cert_manage {
    if $server_cert_file == undef {
      fail('You must specify a source to manage the server cert.')
    } else {
      $server_cert = '/etc/nsd/nsd_server.pem'
      file { $server_cert:
        ensure  => present,
        mode    => '0640',
        owner   => 0,
        group   => 0,
        source  => $server_cert_file,
        require => File['/etc/nsd'],
        before  => Concat::Fragment['nsd-remote'],
      }
    }
  } else {
    $server_cert = $server_cert_file
  }

  if $control_key_manage {
    if $control_key_file == undef {
      fail('You must specify a source to manage the control key.')
    } else {
      $control_key = '/etc/nsd/nsd_control.key'
      file { $control_key:
        ensure  => present,
        mode    => '0640',
        owner   => 0,
        group   => 0,
        source  => $control_key_file,
        require => File['/etc/nsd'],
        before  => Concat::Fragment['nsd-remote'],
      }
    }
  } else {
    $control_key = $control_key_file
  }

  if $control_cert_manage {
    if $control_cert_file == undef {
      fail('You must specify a source to manage the control cert.')
    } else {
      $control_cert = '/etc/nsd/nsd_control.pem'
      file { $control_cert:
        ensure  => present,
        mode    => '0640',
        owner   => 0,
        group   => 0,
        source  => $control_cert_file,
        require => File['/etc/nsd'],
        before  => Concat::Fragment['nsd-remote'],
      }
    }
  } else {
    $control_cert = $control_cert_file
  }

  concat::fragment { 'nsd-remote':
    order   => '02',
    target  => $config_file,
    content => template($config_template),
  }
}

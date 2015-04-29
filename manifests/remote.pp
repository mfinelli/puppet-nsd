# Configure nsd remote.
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

  if $server_key_manage {
    if $server_key_file == undef {
      fail('You must specify a source to manage the server key.')
    } else {
      $server_key = '/etc/nsd/nsd_server.key'
      file { $server_key:
        ensure => present,
        mode   => '0640',
        owner  => 0,
        group  => 0,
        source => $server_key_file,
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
        ensure => present,
        mode   => '0640',
        owner  => 0,
        group  => 0,
        source => $server_cert_file,
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
        ensure => present,
        mode   => '0640',
        owner  => 0,
        group  => 0,
        source => $control_key_file,
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
        ensure => present,
        mode   => '0640',
        owner  => 0,
        group  => 0,
        source => $control_cert_file,
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

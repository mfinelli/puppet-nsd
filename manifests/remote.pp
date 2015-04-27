# Configure nsd remote.
class nsd::remote (
  $config            = undef,
  $enable            = true,
  $interface         = ['127.0.0.1', '::1'],
  $port              = 8952,
  $server_key_file   = undef,
  $server_cert_file  = undef,
  $control_key_file  = undef,
  $control_cert_file = undef,
) {
  if $config == undef {
    include nsd::params
    $config_file = $nsd::params::config
  } else {
    $config_file = $config
  }

  concat::fragment { 'nsd-remote':
    order => '02',
    target => $config_file,
    content => template('nsd/remote.erb'),
  }
}

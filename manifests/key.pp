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

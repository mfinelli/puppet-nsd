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

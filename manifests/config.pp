# Configure nsd.
class nsd::config inherits nsd {
  concat { $config:
    ensure  => present,
    owner   => 0,
    group   => 0,
    mode    => '0644',
  }

  concat::fragment { 'nsd-server':
    order => '01',
    target => $config,
    content => template($config_template),
  }
}

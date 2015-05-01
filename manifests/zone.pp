define nsd::zone (
  $config          = undef,
  $config_template = 'nsd/zone.erb',
  $zonefile_manage = false,
  $zonefile        = undef,
  $options         = {},
) {
  if $config == undef {
    include nsd::params
    $config_file = $nsd::params::config
  } else {
    $config_file = $config
  }

  if $zonefile_manage {
    $zonefile_path = "/etc/nsd/${name}.zone"
    file { $zonefile_path:
      ensure => present,
      mode   => '0644',
      owner  => 0,
      group  => 0,
      source => $zonefile,
      before => Concat::Fragment["nsd-zone-${name}"],
    }
  } else {
    $zonefile_path = $zonefile
  }

  concat::fragment { "nsd-zone-${name}":
    order   => '05',
    target  => $config_file,
    content => template($config_template),
  }
}

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
  $zonefile_path = "/etc/nsd/${name}.zone"
  file { $zonefile_path:
    ensure => present,
    mode   => '0644',
    owner  => 0,
    group  => 0,
    content => template('nsd/zonefile.erb'),
  }

  if $include_in_config {
    ::nsd::zone { $name:
      zonefile => $zonefile_path,
      options  => $include_options,
    }
  }
}

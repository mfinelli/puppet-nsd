define nsd::pattern::master (
  $slave_server = undef,
  $slave_key    = undef,
  $options      = {},
) {
  $notify = "${slave_server} ${slave_key}"
  $master_options = {
    'notify'      => $notify,
    'provide-xfr' => $notify,
  }

  $merged_options = merge($master_options, $options)
  ::nsd::pattern { "to_slave_${slave_server}":
    options => $merged_options,
  }
}

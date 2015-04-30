define nsd::pattern::slave (
  $master_server = undef,
  $transfer_mode = 'AXFR',
  $master_key    = undef,
  $options       = {},
) {
  $allow_notify = "${master_server} ${master_key}"
  $request_transfer = "${transfer_mode} ${allow_notify}"
  $slave_options = {
    'allow-notify' => $allow_notify,
    'request-xfr'  => $request_transfer,
  }

  $merged_options = merge($slave_options, $options)
  ::nsd::pattern { "from_master_${master_server}":
    options => $merged_options,
  }
}

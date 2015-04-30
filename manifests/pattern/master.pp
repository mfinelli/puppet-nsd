define nsd::pattern::master (
  $notify_server = undef,
  $notify_key    = undef,
  $options       = {},
) {
  $notify = "${notify_server} ${notify_key}"
  $master_options = {
    'notify'      => $notify,
    'provide-xfr' => $notify,
  }

  $merged_options = merge($master_options, $options)
  ::nsd::pattern { "to_slave_${notify_server}":
    options => $merged_options,
  }
}

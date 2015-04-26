# Parameters for nsd.
class nsd::params {
  $package_name    = 'nsd'
  $package_ensure  = 'present'
  $service_enable  = true
  $service_name    = 'nsd'
  $service_ensure  = 'running'
  $service_manage  = true
  $config          = '/etc/nsd/nsd.conf'
  $config_template = 'nsd/nsd.conf.erb'
}

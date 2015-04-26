# Install the nsd package.
class nsd::install inherits nsd {
  package { 'nsd':
    ensure => $package_ensure,
    name   => $package_name,
  }
}

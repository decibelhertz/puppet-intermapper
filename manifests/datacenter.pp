class intermapper::datacenter inherits intermapper::params {
  package { 'intermapper-datacenter':
    name   => $dc_package_name,
    ensure => 'installed',
  }
}

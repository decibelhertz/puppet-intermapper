class intermapper inherits intermapper::params {

  package {'intermapper':
    name   => $intermapper::params::package_name,
    ensure => 'installed',
  }

}

class intermapper::install inherits intermapper::params {

  package {'intermapper':
    name   => $intermapper::install::package_name,
    source => $intermapper::install::package_source,
    ensure => 'installed',
  }

}

class intermapper::install inherits intermapper::params {

  package {'intermapper':
    name     => $package_name,
    source   => $package_source,
    provider => $package_provider,
    ensure   => 'installed',
  }

}

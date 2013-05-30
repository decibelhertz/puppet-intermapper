class intermapper::service inherits intermapper::params {
  service { 'intermapperd':
    name     => $service_name,
    ensure   => 'running',
    provider => $service_provider,
  }
}

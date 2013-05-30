class intermapper::service inherits intermapper::params {

  $intermapperd_status = $service_status_cmd ? {
    undef   => undef,
    default => "$service_status_cmd intermapperd",
  }

  service { 'intermapperd':
    name     => $service_name,
    ensure   => 'running',
    provider => $service_provider,
    status   => $intermapperd_status,
  }
}

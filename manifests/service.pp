class intermapper::service inherits intermapper::params {

  service { 'intermapperd':
    name       => $service_name,
    ensure     => 'running',
    provider   => $service_provider,
    status     => $service_status_cmd,
    hasstatus  => true,
    hasrestart => $service_has_restart,
  }
}

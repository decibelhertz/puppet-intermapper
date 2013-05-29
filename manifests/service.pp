class intermapper::service inherits intermapper::params {
  service { 'intermapperd':
    name   => $intermapper::service_name,
    ensure => 'running'
  }
}

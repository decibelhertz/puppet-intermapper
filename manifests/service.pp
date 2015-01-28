class intermapper::service {
  # TODO: Consider making this class private?
  #private("Only should be called from the ${module_name} module")

  $manage_service_enable = $intermapper::service_ensure ? {
    true      => true,
    'running' => true,
    false     => false,
    'stopped' => false,
  }

  if $::intermapper::service_manage {
    service { $intermapper::service_name :
      ensure     => $intermapper::service_ensure,
      enable     => $manage_service_enable,
      provider   => $intermapper::service_provider,
      status     => $intermapper::service_status_cmd,
      hasstatus  => true,
      hasrestart => $intermapper::service_has_restart,
    }
  }
}

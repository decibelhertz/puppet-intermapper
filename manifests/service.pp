class intermapper::service {
  # TODO: Consider making this class private?
  #private("Only should be called from the ${module_name} module")

  if $::intermapper::service_manage {
    service { $intermapper::service_name :
      ensure     => $intermapper::service_ensure,
      provider   => $intermapper::service_provider,
      status     => $intermapper::service_status_cmd,
      hasstatus  => true,
      hasrestart => $intermapper::service_has_restart,
    }
  }
}

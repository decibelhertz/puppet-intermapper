# Manage InterMapper service
class intermapper::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $manage_service_enable = $intermapper::service_ensure ? {
    'running' => true,
    'stopped' => false,
  }

  if $intermapper::service_manage {
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

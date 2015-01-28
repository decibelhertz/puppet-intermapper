#
# == Class: intermapper::service_extra
#
# Manages the InterMapper DataCenter and InterMapper Flows services.
#
# This is a separate class so that other modules can continue to set notifiers
# on Class['intermapper::service'] and not restart imdc or imflows
#
class intermapper::service_extra {
  # TODO: Consider making this class private?
  #private("Only should be called from the ${module_name} module")

  $manage_imflows_enable = $intermapper::service_imflows_ensure ? {
    true      => true,
    'running' => true,
    false     => false,
    'stopped' => false,
  }

  $manage_imdc_enable = $intermapper::service_imdc_ensure ? {
    true      => true,
    'running' => true,
    false     => false,
    'stopped' => false,
  }

  if $::intermapper::service_manage {
    if $::intermapper::service_imflows_manage {
      service { $intermapper::service_imflows_name :
        ensure     => $intermapper::service_imflows_ensure,
        enable     => $manage_imflows_enable,
        provider   => $intermapper::service_provider,
        status     => $intermapper::service_status_cmd,
        hasstatus  => true,
        hasrestart => $intermapper::service_has_restart,
      }
    }
    if $::intermapper::service_imdc_manage {
      service { $intermapper::service_imdc_name :
        ensure     => $intermapper::service_imdc_ensure,
        enable     => $manage_imdc_enable,
        provider   => $intermapper::service_provider,
        status     => $intermapper::service_status_cmd,
        hasstatus  => true,
        hasrestart => $intermapper::service_has_restart,
      }
    }
  }
}

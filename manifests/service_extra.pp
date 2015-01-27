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

  if $::intermapper::service_manage {
    service { $intermapper::service_imflows_name :
      ensure     => $intermapper::service_imflows_ensure,
      provider   => $intermapper::service_provider,
      status     => $intermapper::service_status_cmd,
      hasstatus  => true,
      hasrestart => $intermapper::service_has_restart,
    }
    service { $intermapper::service_imdc_name :
      ensure     => $intermapper::service_imdc_ensure,
      provider   => $intermapper::service_provider,
      status     => $intermapper::service_status_cmd,
      hasstatus  => true,
      hasrestart => $intermapper::service_has_restart,
    }
  }
}

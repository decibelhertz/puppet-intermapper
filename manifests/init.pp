class intermapper (
  $basedir             = $intermapper::params::basedir,
  $settingsdir         = $intermapper::params::settingsdir,
  $package_ensure      = 'present',
  $package_manage      = true,
  $package_name        = $intermapper::params::package_name,
  $package_provider    = $intermapper::params::package_provider,
  $service_ensure      = 'running',
  $service_manage      = true,
  $service_name        = $intermapper::params::service_name,
  $service_provider    = $intermapper::params::service_provider,
  $service_status_cmd  = $intermapper::params::service_status_cmd,
  $service_has_restart = $intermapper::params::service_has_restart,
  $toolsdir            = $intermapper::params::toolsdir,
  $nagios_ensure       = 'present',
  $nagios_manage       = false,
  $nagios_plugins_dir  = 'UNSET',
  $nagios_link_plugins = $intermapper::params::nagios_link_plugins,
) inherits intermapper::params {
  validate_bool($nagios_manage)
  validate_bool($package_manage)
  validate_bool($service_manage)
  validate_bool($service_has_restart)
  validate_re($nagios_ensure, ['^present','^absent','^missing'])

  if $nagios_manage {
    if $nagios_ensure == 'present' and $nagios_plugins_dir == 'UNSET' {
      fail(
        'nagios_plugins_dir must be specified when nagios_ensure is "present"')
    }
  }


  anchor {'intermapper::begin': } ->
  class {'::intermapper::install': } ->
  class {'::intermapper::nagios': } ~>
  class {'::intermapper::service': } ->
  anchor {'intermapper::end': }
}

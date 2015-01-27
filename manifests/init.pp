#
# == Class: intermapper
#
# Manage the Intermapper network monitoring package by Help/Systems
#
# === Parameters
# [*basedir*]
#   The base directory where Intermapper is installed. Defaults to /usr/local
#   by the package. Useful if the package has been relocated
#
# [*vardir*]
#   The directory that contains the InterMapper_Settings directory. Typically
#   /var/local on newer versions of intermapper, but old versions had this set
#   to /usr/local
#
# [*package_ensure*]
#   Defaults to 'present'. Can be set to a specific version of Intermapper,
#   or to 'latest' to ensure the package is always upgraded.
#
# [*package_manage*]
#   If false, the package will not be managed by this class. Defaults to true.
#
# [*package_name*]
#   The name (or names) of the package to be installed. Defaults are
#    OS-specific but you may override them here
#
# [*package_provider*]
#   Normally undefined, this is set to 'sun' on Solaris platforms to work
#   with sites that have set their default package provider to something
#   different.
#
# [*service_ensure*]
#   Defaults to running. Can be any valid value for the ensure parameter for a
#   service resource type.
#
# [*service_manage*]
#   Defaults to true. If false, the service is not managed.
#
# [*service_name*]
#   The name of the service(s) to managed. Defaults to "intermapperd"
#
# [*service_provider*]
#   Normally undefined, this is set to 'init' on Solaris platforms since
#   Intermapper doesn't ship with an SMF service manifest on Solaris.
#
# [*service_status_cmd*]
#   Normally undefined, this is set to use pgrep on Solaris platforms to make
#   up for the lack of a status action in the Solaris init script provided with
#   Intermapper
#
# [*service_has_restart*]
#   Normally false except on Solaris. Controls the behavior of the service
#   restart logic in Puppet.
#
# [*nagios_ensure*]
#   If nagios_manage is true, this controls whether Nagios resources are added
#   or removed. Defaults to 'present'. Requires nagios_plugins_dir to be set
#   unless nagios_ensure is set to 'missing' or 'absent'.
#
# [*nagios_manage*]
#   Defaults to false. If false, no Nagios resources are managed. See caveat
#   above about nagios_plugins_dir.
#
# [*nagios_plugins_dir*]
#   Location on the system where Nagios plugins typically live. Determining this
#   is out of scope for this module, but you might try /usr/lib64/nagios-plugins
#   on RHEL/CentOS 6.x. Note that this variable must be set if nagios_manage is
#   true and nagios_ensure is 'present'.
#
# [*nagios_link_plugins*]
#   A list of plugin names that should be symlinked from nagios_plugin_dir into
#   $vardir/InterMapper_Settings/Tools for use by Intermapper probe definitions.
#
class intermapper (
  $basedir             = '/usr/local',
  $vardir              = $intermapper::params::vardir,
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

  $settingsdir="${vardir}/InterMapper_Settings"
  $toolsdir="${settingsdir}/Tools"

  anchor {'intermapper::begin': } ->
  class {'::intermapper::install': } ->
  class {'::intermapper::nagios': } ~>
  class {'::intermapper::service': } ->
  anchor {'intermapper::end': }
}

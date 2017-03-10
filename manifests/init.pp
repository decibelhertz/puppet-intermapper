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
# [*owner*]
#   The owner of any files that this module installs. Default: intermapper
#
# [*group*]
#   The group of any files that this module installs. Default: intermapper
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
#   Defaults to true. If false, none of the services are managed. Disables
#   service_extra_manage.
#
# [*service_imdc_manage*]
#   Controls whether the extra service imdc is managed. Dependent
#   on service_manage being true. Defaults to true. If false, the extra
#   service imdc is not managed.
#
# [*service_imflows_manage*]
#   Controls whether the extra service imflows is managed. Dependent
#   on service_manage being true. Defaults to true. If false, the extra
#   service imflows is not managed.
#
# [*service_imdc_ensure*]
#   Defaults to stopped. If service_manage is true, the Intermapper Datacenter
#   services are set to this value.
#
# [*service_imflows_ensure*]
#   Defaults to stopped. If service_manage is true, the IMFlows services are
#   set to this value.
#
# [*service_name*]
#   The name of the service(s) to manage. Defaults to "intermapperd"
#
# [*service_imdc_name*]
#   The name of the InterMapper Datacenter service(s) to manage. Defaults to
#   "imdc"
#
# [*service_imflows_name*]
#   The name of the IMFlows service(s) to manage. Defaults to "imflows"
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
# ===Usage
#
# The classes intermapper::service, intermapper::service_extra,
# intermapper::install, and intermapper::nagios are not intended to be called
# directly outside of this module. They can be used as notifiers and
# subscription points however, so probes can be installed and the
# Class[intermapper::service] can be set to subscribe to the probe files.
#
class intermapper (
  $basedir                = '/usr/local',
  $vardir                 = '/var/local',
  $owner                  = 'intermapper',
  $group                  = 'intermapper',
  $package_ensure         = 'present',
  $package_manage         = true,
  $package_name           = $intermapper::params::package_name,
  $package_provider       = $intermapper::params::package_provider,
  $package_source         = undef,
  $service_manage         = true,
  $service_imdc_manage    = true,
  $service_imflows_manage = true,
  $service_ensure         = 'running',
  $service_imdc_ensure    = 'stopped',
  $service_imflows_ensure = 'stopped',
  $service_name           = $intermapper::params::service_name,
  $service_imdc_name      = 'imdc',
  $service_imflows_name   = 'imflows',
  $service_provider       = $intermapper::params::service_provider,
  $service_status_cmd     = $intermapper::params::service_status_cmd,
  $service_has_restart    = $intermapper::params::service_has_restart,
  $nagios_ensure          = 'present',
  $nagios_manage          = false,
  $nagios_plugins_dir     = undef,
  $nagios_link_plugins    = $intermapper::params::nagios_link_plugins,
) inherits intermapper::params {
  validate_bool($nagios_manage)
  validate_bool($package_manage)
  validate_bool($service_manage)
  validate_bool($service_has_restart)
  validate_re($nagios_ensure, ['^present','^absent','^missing'])

  if $nagios_manage {
    if $nagios_ensure == 'present' and $nagios_plugins_dir == undef {
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
  class {'::intermapper::service_extra': } ->
  anchor {'intermapper::end': }
}

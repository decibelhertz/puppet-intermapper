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
# [*firewall_defaults*]
#   A Hash that allows you to tune the default parameters handed off to
#   managed firewall resources. Default sets ctstate to NEW and action to
#   accept.
#
# [*firewall_ipv4_manage*]
#   A Boolean that chooses whether or not to manage IPv4 firewall resources.
#   Default is false.
#
# [*firewall_ipv6_manage*]
#   A Boolean that chooses whether or not to manage IPv6 firewall resources.
#   Default is false.
#
# [*firewall_ports_tcp*]
#   An Array/String/Integer that chooses the TCP ports to open in the firewall.
#   Default is 80 (HTTP), 443 (HTTPS) and 8181 (IM RemoteAccess).
#
# [*firewall_ports_udp*]
#   An Array/String/Integer that chooses the UDP ports to open in the firewall.
#   Default is 162 (SNMPTRAP) and 8181 (IM RemoteAccess).
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
# [*nagios_plugins_package_name*]
#   String or Array of nagios plugin packages to install, if any. Set
#   to undef or empty array to avoid installing anything.
#
# [*font_package_name*]
#   String or Array of font packages to install, if any. Set
#   to undef or empty array to avoid installing anything.
#
# [*intermapper_icons*]
#   A Hash that creates intermapper::icon resources.
#
# [*intermapper_mibfiles*]
#   A Hash that creates intermapper::mibfile resources.
#
# [*intermapper_probes*]
#   A Hash that creates intermapper::probes resources.
#
# [*intermapper_tools*]
#   A Hash that creates intermapper::tools resources.
#
# [*intermapper_service_limits*]
#   A Hash that creates intermapper::service_limits resources.
#
# ===Usage
#
# The classes intermapper::service, intermapper::service_extra,
# intermapper::install, intermapper::config and intermapper::nagios are not
# intended to be called directly outside of this module. They can be used as
# notifiers and subscription points however, so probes can be installed and the
# Class[intermapper::service] can be set to subscribe to the probe files.
#
class intermapper (
  Stdlib::Absolutepath $basedir,
  Stdlib::Absolutepath $vardir,
  Stdlib::Absolutepath $conf_file,
  String $owner,
  String $group,
  String $conf_owner,
  String $conf_group,
  Enum[absent,latest,present] $package_ensure,
  Boolean $package_manage,
  Boolean $service_manage,
  Boolean $service_imdc_manage,
  Boolean $service_imflows_manage,
  Enum[running,stopped] $service_ensure,
  Enum[running,stopped] $service_imdc_ensure,
  Enum[running,stopped] $service_imflows_ensure,
  String $service_name,
  String $service_imdc_name,
  String $service_imflows_name,
  Boolean $service_has_restart,
  Enum[present,absent] $nagios_ensure,
  Boolean $nagios_manage,
  Array $nagios_link_plugins,
  Hash $intermapper_icons,
  Hash $intermapper_mibfiles,
  Hash $intermapper_probes,
  Hash $intermapper_tools,
  Hash $intermapper_service_limits,
  Hash $firewall_defaults,
  Boolean $firewall_ipv4_manage,
  Boolean $firewall_ipv6_manage,
  Variant[Integer,String,Array] $firewall_ports_tcp,
  Variant[Integer,String,Array] $firewall_ports_udp,
  Array $nagios_plugins_package_name,
  Optional[String] $service_user,
  Optional[String] $service_group,
  Optional[Stdlib::Absolutepath] $service_pidfile,
  Optional[Stdlib::Absolutepath] $service_settingsfolder,
  Optional[String] $service_fontfolder,
  Optional[String] $service_listen,
  Optional[Variant[Array,String]] $package_name,
  Optional[Variant[Array,String]] $font_package_name,
  Optional[String] $package_provider,
  Optional[String] $package_source,
  Optional[String] $service_provider,
  Optional[String] $service_status_cmd,
  Optional[Stdlib::Absolutepath] $nagios_plugins_dir,
) {
  validate_re('^Linux$', $::kernel, "${::kernel} unsupported")

  if $nagios_manage
  and $nagios_ensure == 'present'
  and $nagios_plugins_dir == undef {
    fail('nagios_plugins_dir must be specified when nagios_ensure is "present"')
  }

  $settingsdir = "${vardir}/InterMapper_Settings"

  Class['intermapper::install']
  -> Class['intermapper::config']
  ~> Class['intermapper::service']
  -> Class['intermapper::service_extra']
  -> Class['intermapper::firewall']

  contain 'intermapper::install'
  contain 'intermapper::config'
  contain 'intermapper::service'
  contain 'intermapper::service_extra'
  contain 'intermapper::firewall'
}

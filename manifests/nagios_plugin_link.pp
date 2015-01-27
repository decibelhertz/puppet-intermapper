#
# == Defined type: intermapper::nagios_plugin_link
#
# Symlink a Nagios probe into the Intermapper Tools directory for use by a
# Intermapper probe definition without having to manage the probe definition's
# path
#
# === Parameters
# [*nagios_pluginsdir*]
#   The directory containing the Nagios probe script
#   Usually something like /usr/lib64/nagios-plugins on RedHat
#
# [*ensure*]
#   Remove the link if 'absent' or 'missing', create it otherwise
#
# === Other Variables affecting operation
# The intermapper class takes a few parameters that affect the operation of
# this defined type, notably:
# [*intermapper::toolsdir*]
#   This is where Intermapper expects to find scripts on it's default path,
#   and is the directory where Nagios plugins should be symlinked to.
define intermapper::nagios_plugin_link (
  $nagios_plugins_dir,
  $ensure = 'present',
){

  include 'intermapper'
  $manage_ensure = $ensure ? {
    'absent'  => 'absent',
    'missing' => 'absent',
    'present' => 'link',
    default   => 'link',
  }

  $manage_source = $manage_ensure ? {
    'link'  => "${nagios_plugins_dir}/${name}",
    default => undef,
  }

  file { "${intermapper::toolsdir}/${name}" :
    ensure => $manage_ensure,
    source => $manage_source,
    notify => Class['::intermapper::service'],
  }

}

#
# == define: intermapper::mibfile
#
# Install a new SNMP MIB into Intermapper's MIB Files directory
#
# ===Parameters
#
# [*ensure*]
#   works just like a file resource
#
# [*mibname*]
#   (namevar) The filename of the MIB File. Usually something like 'fa_40.mib'
#
# [*target*]
#   If ensure is set to link, then link_target is used as the target parameter
#   for the underlying file resource. This attribute is mutually exclusive with
#   source and content.
#
# [*source*]
#   The source for the file, as a Puppet resource path. This attribute is
#   mutally exclusive with soruce and target.
#
# [*content*]
#   The desired contents of a file, as a string. This attribute is mutually
#   exclusive with source and target.
#

define intermapper::mibfile (
  $mibname = $title,
  $ensure  = 'present',
  $target  = undef,
  $source  = undef,
  $content = undef,
  $force   = undef,
  $mode    = undef,
) {
  include 'intermapper'

  $mibdir = "${intermapper::settingsdir}/MIB Files"

  file { "${mibdir}/${mibname}" :
    ensure  => $ensure,
    target  => $target,
    source  => $source,
    content => $content,
    force   => $force,
    mode    => $mode,
    owner   => $intermapper::owner,
    group   => $intermapper::group,
    require => Class['intermapper::install'],
    notify  => Class['intermapper::service'],
  }
}

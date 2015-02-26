#
# == define: intermapper::tool
#
# Install a new Intermapper tool into Intermapper's Tools directory.
#
# InterMapper looks in the Tools directory for scripts if the path isn't
# set in the probe definition. This is also a good place to put libraries that
# probes may need.
#
# ===Parameters
#
# [*ensure*]
#   works just like a file resource
#
# [*toolname*]
#   (namevar) The filename of the Intermapper Tool. Usually
#   something like 'edu.ucsd.antelope.check_q330' or 'nagios_q330_ping'
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
# [*mode*]
#   File mode, same format as a file resource.
#
define intermapper::icon (
  $iconname = $title,
  $ensure = 'present',
  $target = undef,
  $source = undef,
  $content = undef,
  $force = undef,
  $mode = undef,
) {
  include 'intermapper'

  $iconsdir = "${intermapper::settingsdir}/Custom Icons"

  file { "${iconsdir}/${iconname}" :
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

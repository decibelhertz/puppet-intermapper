#
# == define: intermapper::probe
#
# Install a new Intermapper probe into Intermapper's Probes directory
#
# ===Parameters
#
# [*ensure*]
#   works just like a file resource
#
# [*probename*]
#   (namevar) The filename of the Intermapper Probe definition. Usually
#   something like 'edu.ucsd.antelope.check_q330'
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
define intermapper::probe (
  $probename = $title,
  $ensure = 'present',
  $target = undef,
  $source = undef,
  $content = undef,
  $force = undef,
) {
  include 'intermapper'

  $probedir = "${intermapper::settingsdir}/Probes"

  file { "${probedir}/${probename}" :
    ensure  => $ensure,
    target  => $target,
    source  => $source,
    content => $content,
    force   => $force,
    require => Class['intermapper::install'],
    notify  => Class['intermapper::service'],
  }
}

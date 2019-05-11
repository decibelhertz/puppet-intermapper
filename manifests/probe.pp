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
define intermapper::probe(
  Enum[file,absent] $ensure = 'file',
  String $probename = $title,
  Optional[String] $target = undef,
  Optional[String] $source = undef,
  Optional[String] $content = undef,
  Optional[Boolean] $force = undef,
  Optional[String] $mode = undef,
  Optional[Boolean] $recurse = undef,
) {

  intermapper::file { $probename :
    ensure   => $ensure,
    filetype => 'probe',
    target   => $target,
    source   => $source,
    content  => $content,
    force    => $force,
    mode     => $mode,
    recurse  => $recurse,
  }
}

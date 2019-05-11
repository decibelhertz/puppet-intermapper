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
define intermapper::mibfile(
  Enum[file,link,absent] $ensure = 'file',
  String $mibname = $title,
  Optional[String] $target = undef,
  Optional[String] $source = undef,
  Optional[String] $content = undef,
  Optional[Boolean] $force = undef,
  Optional[String] $mode = undef,
  Optional[Boolean] $recurse = undef,
) {
  include 'intermapper'

  intermapper::file { "MIB Files/${mibname}":
    ensure   => $ensure,
    filetype => 'mibfile',
    target   => $target,
    source   => $source,
    content  => $content,
    force    => $force,
    mode     => $mode,
    recurse  => $recurse,
  }
}

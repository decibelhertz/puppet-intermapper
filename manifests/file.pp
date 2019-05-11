#
# == define: intermapper::file
#
# Install a new Intermapper file into Intermapper.
#
# InterMapper has several directories that we want to pouplate with data.
# This type serves as a macro so that we are ensuring proper ownership,
# notifications, etc.
#
# ===Parameters
#
# [*filetype*]
#   File type, which controls what settings subdirectory our file ends
#   up in.
#
# [*ensure*]
#   works just like a file resource
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
define intermapper::file(
  Enum[icon,certificate,extension,mibfile,probe,sound,tool,webpage,translation]
  $filetype,
  Enum[file,link,absent] $ensure = 'file',
  Optional[String] $target = undef,
  Optional[String] $source = undef,
  Optional[String] $content = undef,
  Optional[Boolean] $force = undef,
  Optional[String] $mode = undef,
  Optional[Boolean] $recurse = undef,
) {
  include 'intermapper'

  $subdir = $filetype ? {
    'automate'    => 'AutoMate',
    'certificate' => 'Certificates',
    'extension'   => 'Extension',
    'icon'        => 'Custom Icons',
    'mibfile'     => 'MIB Files',
    'probe'       => 'Probes',
    'sound'       => 'Sounds',
    'tool'        => 'Tools',
    'translation' => 'Translations',
    'webpage'     => 'Web Pages',
  }

  file { "${intermapper::settingsdir}/${subdir}/${title}":
    ensure  => $ensure,
    target  => $target,
    source  => $source,
    content => $content,
    force   => $force,
    mode    => $mode,
    recurse => $recurse,
    owner   => $intermapper::owner,
    group   => $intermapper::group,
    require => Class['intermapper::install'],
    notify  => Class['intermapper::service'],
  }
}

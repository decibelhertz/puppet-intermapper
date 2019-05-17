#
# == define: intermapper::file
#
# Install a file into Intermapper, generically.
#
# InterMapper has several subdirectories that we want to populate with
# data.
#
# ===Parameters
#
# [*subdir*]
#   Subdirectory, which controls what settings subdirectory our file
#   ends up in. This is based on the default directories we could want
#   to affect in InterMapper.
#
# [*all other parameters*]
#   Same as file resource per https://puppet.com/docs/puppet/5.5/types/file.html
#
define intermapper::file(
  Enum['AutoMate', 'Certificates', 'Custom Icons', 'Extensions',
    'MIB Files',  'Probes', 'Sounds', 'Tools', 'Translations',
    'Web Pages'] $subdir,
  Enum['file', 'directory', 'link', 'absent'] $ensure = 'file',
  Optional $backup = undef,
  Optional $checksum = undef,
  Optional $checksum_value = undef,
  Optional[String] $content = undef,
  Optional[Variant[Boolean,Enum['yes','no']]] $force = undef,
  Optional $ignore = undef,
  Optional[Enum['follow','manage']] $links = undef,
  Optional[String] $mode = '0644',
  Optional[Stdlib::Absolutepath] $path = undef,
  Optional $provider = undef,
  Optional[Variant[Boolean,Enum['yes','no']]] $purge = undef,
  Optional[Variant[Boolean,Enum['remote']]] $recurse = undef,
  Optional $recurselimit = undef,
  Optional[Variant[Boolean,Enum['yes','no']]] $replace = undef,
  Optional[Boolean] $selinux_ignore_defaults = undef,
  Optional $selrange = undef,
  Optional $selrole = undef,
  Optional $seltype = undef,
  Optional $seluser = undef,
  Optional[Variant[Boolean,Enum['yes','no']]] $show_diff = undef,
  Optional[String] $source = undef,
  Optional[Enum['use','use_when_creating','ignore']] $source_permissions = undef,
  Optional[Enum['first','all']] $sourceselect = undef,
  Optional[String] $target = undef,
  Optional $validate_cmd = undef,
  Optional $validate_replacement = undef,
) {
  include 'intermapper'

  file { "${intermapper::settingsdir}/${subdir}/${title}":
    ensure                  => $ensure,
    backup                  => $backup,
    checksum                => $checksum,
    checksum_value          => $checksum_value,
    content                 => $content,
    force                   => $force,
    group                   => $intermapper::group,
    ignore                  => $ignore,
    links                   => $links,
    mode                    => $mode,
    owner                   => $intermapper::owner,
    path                    => $path,
    provider                => $provider,
    purge                   => $purge,
    recurse                 => $recurse,
    recurselimit            => $recurselimit,
    replace                 => $replace,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    selrange                => $selrange,
    selrole                 => $selrole,
    seltype                 => $seltype,
    seluser                 => $seluser,
    show_diff               => $show_diff,
    source                  => $source,
    source_permissions      => $source_permissions,
    sourceselect            => $sourceselect,
    target                  => $target,
    validate_cmd            => $validate_cmd,
    validate_replacement    => $validate_replacement,
    require                 => Class['intermapper::install'],
    notify                  => Class['intermapper::service'],
  }
}

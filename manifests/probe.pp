#
# == define: intermapper::probe
#
# Install a new Intermapper probe into Intermapper's Icons directory
#
# ===Parameters
#
# [*ensure*]
#   Same as file resource. The InterMapper Probes dir is flat, however,
#   so ensure => directory is not permitted.
#
# [*probename*]
#   (namevar) The filename of the Intermapper Icons definition. Usually
#   something like 'edu.ucsd.antelope.check_q330'
#
# [*all other parameters*]
#   Same as file resource per https://puppet.com/docs/puppet/5.5/types/file.html
define intermapper::probe(
  Enum['file', 'link', 'absent'] $ensure = 'file',
  String $probename = $title,
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

  file { "${intermapper::settingsdir}/Probes/${probename}":
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

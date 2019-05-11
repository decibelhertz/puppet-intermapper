# Manage intermapper config
class intermapper::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { $intermapper::conffile :
    ensure  => 'file',
    content => epp('intermapper/intermapperd.conf.epp'),
    owner   => $intermapper::owner,
    group   => $intermapper::group,
    mode    => '0644',
  }

  contain intermapper::nagios

  create_resources('intermapper::icon', $intermapper::intermapper_icons)
  create_resources('intermapper::file', $intermapper::intermapper_files)
  create_resources('intermapper::mibfile', $intermapper::intermapper_mibfiles)
  create_resources('intermapper::probe', $intermapper::intermapper_probes)
  create_resources('intermapper::tool', $intermapper::intermapper_tools)
}

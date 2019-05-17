# Plugins that should be linked from the main Nagios plugin directory
# to Intermapper's Tools directory.
# Requires intermapper::nagios_link_plugins and
# intermapper::nagios_pluginsdir to be set
class intermapper::nagios {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $manage_ensure = $intermapper::nagios_ensure ? {
    'present' => 'link',
    default   => $intermapper::nagios_ensure,
  }

  if $intermapper::nagios_manage {
    $intermapper::nagios_link_plugins.each |String $plugin| {
      intermapper::tool { $plugin :
        ensure => $manage_ensure,
        target => "${intermapper::nagios_plugins_dir}/${plugin}",
      }
    }
  }
}

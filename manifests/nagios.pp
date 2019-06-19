# Plugins that should be linked from the main Nagios plugin directory
# to Intermapper's Tools directory.
# Requires intermapper::nagios_link_plugins and
# intermapper::nagios_pluginsdir to be set
class intermapper::nagios {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $intermapper::nagios_manage
  and $intermapper::nagios_ensure == 'present'
  and $intermapper::nagios_plugins_dir == undef {
    fail('nagios_plugins_dir must be specified when nagios_ensure is "present"')
  }

  $_ensure = $intermapper::nagios_ensure ? {
    'present' => 'link',
    default   => $intermapper::nagios_ensure,
  }

  if $intermapper::nagios_manage {
    $intermapper::nagios_link_plugins.each |String $plugin| {
      intermapper::tool { $plugin :
        ensure => $_ensure,
        target => "${intermapper::nagios_plugins_dir}/${plugin}",
      }
    }
  }
}

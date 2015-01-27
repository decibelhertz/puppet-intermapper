# Plugins that should be linked from the main Nagios plugin directory to
# Intermapper's Tools directory
# Requires intermapper::nagios_link_plugins and intermapper::nagios_pluginsdir
# to be set
class intermapper::nagios {
  # TODO: Consider making this class private?
  #private("Only should be called from the ${module_name} module")

  if $intermapper::nagios_manage {
    $manage_npdir = $intermapper::nagios_plugins_dir ? {
      'UNSET'     => undef,
      default     => $intermapper::nagios_plugins_dir,
    }
    intermapper::nagios_plugin_link{ $intermapper::nagios_link_plugins :
      ensure             => $intermapper::nagios_ensure,
      nagios_plugins_dir => $manage_npdir,
    }
  }
}

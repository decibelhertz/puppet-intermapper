# Plugins that should be linked from the main Nagios plugin directory to Intermapper's Tools directory
class intermapper::nagios {

  ### Class internal variables
  $link_plugins = [
    'check_nrpe',
    'check_disk',
    'check_file_age',
    'check_icmp',
    'check_mailq',
    'check_tcp',
    'check_udp',
    'check_ftp',
    'check_procs',
    'check_snmp',
  ]

  ### Managed resources
  intermapper::nagios_plugin_link{ $link_plugins : }
}

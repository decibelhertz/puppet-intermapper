# Plugins that should be linked from the main Nagios plugin directory to Intermapper's Tools directory
class intermapper::nagios (
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
){

  include 'nrpe::params'
  include 'intermapper::params'
  ### Class internal variables

  ### Managed resources
  intermapper::nagios_plugin_link{ $link_plugins :
    intermapper_toolsdir=$intermapper::params::toolsdir,
    nagios_pluginsdir=$nrpe::params::pluginsdir,
    require => [ Class['nrpe'], Package['intermapper'] ],
  }
}

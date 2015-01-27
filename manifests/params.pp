class intermapper::params {

  $basedir = $::osfamily ? {
    'Solaris' => '/opt/intermapper',
    default   => '/usr/local',
  }

  $settingsdir = $::osfamily ? {
    'Solaris' => '/opt/intermapper/InterMapper_Settings',
    default   => '/var/local/InterMapper_Settings',
  }

  $package_name = $::osfamily ? {
    'Solaris' => 'DARTinter',
    default   => 'InterMapper',
  }

  $package_provider = $::osfamily ? {
    'Solaris' => 'sun',
    default   => undef,
  }

  $service_name = $::osfamily ? {
    default   => 'intermapperd',
  }

  $service_provider = $::osfamily ? {
    'Solaris' => 'init',
    default   => undef,
  }

  $service_status_cmd = $::osfamily ? {
    'Solaris' => "/usr/bin/pgrep ${service_name}",
    default   => undef,
  }

  $service_has_restart = $::osfamily ? {
    'Solaris' => false,
    default   => true,
  }

  $toolsdir = "${basedir}/Tools"

  $nagios_link_plugins = [
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

}

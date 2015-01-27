class intermapper::params {

  $package_name = $::osfamily ? {
    'Solaris' => 'DARTinter',
    default   => 'InterMapper',
  }

  $package_provider = $::osfamily ? {
    'Solaris' => 'sun',
    default   => undef,
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

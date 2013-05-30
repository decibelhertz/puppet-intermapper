class intermapper::params {

  $basedir = $::osfamily ? {
    'Solaris' => '/opt/intermapper',
    default   => '/usr/local',
  }

  $settingsdir = $::osfamily ? {
    'Solaris' => '/opt/intermapper/Intermapper_Settings',
    default   => '/var/local/Intermapper_Settings',
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

  $toolsdir = "$basedir/Tools"

  $dc_package_name = $::osfamily ? {
    default => 'InterMapper-DataCenter',
  }
}

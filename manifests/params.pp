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

  $service_name = $::osfamily ? {
    default => 'intermapperd',
  }

  $toolsdir = "$basedir/Tools"
}

class intermapper::params {
  $basedir = $::osfamily ? {
    'Solaris' => '/opt/intermapper',
    default   => '/usr/local/intermapper',
  }

  $package_name = $::osfamily ? {
    'Solaris' => 'DARTinter',
    default   => 'intermapper',
  }

  $toolsdir = "$basedir/Tools"
}

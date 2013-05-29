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

  $package_source = $::osfamily ? {
    'RedHat' => 'http://download.dartware.com/im568/InterMapper-5.6.8-1.i386.4x.rpm',
    default  => undef
  }
}

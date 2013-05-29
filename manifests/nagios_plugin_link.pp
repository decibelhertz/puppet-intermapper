define intermapper::nagios_plugin_link (
  $ensure = 'present'
){
  include 'nrpe::params'
  include 'intermapper::params'

  $manage_ensure = $ensure ? {
    'absent'  => 'absent',
    'missing' => 'absent',
    'present' => 'link',
    default   => 'link',
  }

  file { "${intermapper::params::toolsdir}/${name}" :
    ensure  => $manage_ensure,
    source  => "${nrpe::params::pluginsdir}/${name}",
    require => [ Class['nrpe'], Package['intermapper'] ],
  }

}

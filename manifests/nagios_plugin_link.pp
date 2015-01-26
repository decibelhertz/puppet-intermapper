define intermapper::nagios_plugin_link (
  $intermapper_toolsdir,
  $nagios_pluginsdir,
  $ensure = 'present',
){

  $manage_ensure = $ensure ? {
    'absent'  => 'absent',
    'missing' => 'absent',
    'present' => 'link',
    default   => 'link',
  }

  file { "${intermapper_toolsdir}/${name}" :
    ensure  => $manage_ensure,
    source  => "${nagios_pluginsdir}/${name}",
  }

}

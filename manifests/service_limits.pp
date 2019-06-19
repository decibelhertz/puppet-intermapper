# InterMapper runs on SysV, which is fired off by systemd in modern
# Linux. When we want the service to have elevated privilege, we need
# systemd to set that; the older approach of setting something in
# /etc/security/limits.conf will not work. This can be checked running
# a command like:
#   for i in $(pgrep intermapperd); do cat /proc/${i}/limits; done
# EG
# $ for i in $(pgrep intermapperd); do cat /proc/${i}/limits; done
# Limit                     Soft Limit           Hard Limit           Units
# Max cpu time              unlimited            unlimited            seconds
# Max file size             unlimited            unlimited            bytes
# Max data size             unlimited            unlimited            bytes
# Max stack size            8388608              unlimited            bytes
# Max core file size        0                    unlimited            bytes
# Max resident set          unlimited            unlimited            bytes
# Max processes             31192                31192                processes
# Max open files            1024                 4096                 files
# Max locked memory         65536                65536                bytes
# Max address space         unlimited            unlimited            bytes
# Max file locks            unlimited            unlimited            locks
# Max pending signals       31192                31192                signals
# Max msgqueue size         819200               819200               bytes
# Max nice priority         0                    0
# Max realtime priority     0                    0
# Max realtime timeout      unlimited            unlimited            us
#
# See `man 5 systemd.exec` for details on how to confiugure soft and
# hard settings.
define intermapper::service_limits(
  Enum['present','absent'] $ensure = 'present',
  Enum['intermapperd','imdc','imflows'] $service_name = $title,
  Stdlib::Absolutepath $basedir = '/etc/systemd/system',
  Variant[Integer,String,Undef] $limitcpu = undef,
  Variant[Integer,String,Undef] $limitfsize = undef,
  Variant[Integer,String,Undef] $limitdata = undef,
  Variant[Integer,String,Undef] $limitstack = undef,
  Variant[Integer,String,Undef] $limitcore = undef,
  Variant[Integer,String,Undef] $limitrss = undef,
  Variant[Integer,String,Undef] $limitnofile = undef,
  Variant[Integer,String,Undef] $limitas = undef,
  Variant[Integer,String,Undef] $limitnproc = undef,
  Variant[Integer,String,Undef] $limitmemlock = undef,
  Variant[Integer,String,Undef] $limitlocks = undef,
  Variant[Integer,String,Undef] $limitsigpending = undef,
  Variant[Integer,String,Undef] $limitmsgqueue = undef,
  Variant[Integer,String,Undef] $limitnice = undef,
  Variant[Integer,String,Undef] $limitrtprio = undef,
  Variant[Integer,String,Undef] $limitrttime = undef,
) {
  ## VARIABLES
  $dir_ensure = $ensure ? {
    'present' => 'directory',
    default   => 'absent',
  }
  $file_ensure = $ensure ? {
    'present' => 'file',
    default   => 'absent',
  }
  $notify = $service_name ? {
    'intermapperd' => Class['intermapper::service'],
    default        => Class['intermapper::service_extra'],
  }
  $dirname = "${basedir}/${service_name}.service.d"
  $filename = "${dirname}/limits.conf"
  $epp_params = {
    'service_name' => $service_name,
    'filename'     => $filename,
    'limits'       => delete_undef_values({
      'LimitCPU'        => $limitcpu,
      'LimitFSIZE'      => $limitfsize,
      'LimitDATA'       => $limitdata,
      'LimitSTACK'      => $limitstack,
      'LimitCORE'       => $limitcore,
      'LimitRSS'        => $limitrss,
      'LimitNOFILE'     => $limitnofile,
      'LimitAS'         => $limitas,
      'LimitNPROC'      => $limitnproc,
      'LimitMEMLOCK'    => $limitmemlock,
      'LimitLOCKS'      => $limitlocks,
      'LimitSIGPENDING' => $limitsigpending,
      'LimitMSGQUEUE'   => $limitmsgqueue,
      'LimitNICE'       => $limitnice,
      'LimitRTPRIO'     => $limitrtprio,
      'LimitRTTIME'     => $limitrttime,
    }),
  }

  ## RESOURCES
  file {
    $dirname :
      ensure => $dir_ensure,
      owner  => 'root',
      group  => 'root',
      notify => $notify,;
    $filename :
      ensure  => $file_ensure,
      owner   => 'root',
      group   => 'root',
      content => epp('intermapper/limits.conf.epp', $epp_params),
      notify  => $notify,;
  }

  # systemd has to be told that something changed. Here, we do it the
  # hackiest way possible.
  exec { "${service_name} systemctl daemon-reload":
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    subscribe   => File[$dirname,$filename],
  }
}

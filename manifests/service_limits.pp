# InterMapper tends to run on SysV, which is fired off by systemd in
# modern Linux. When we want the service to have elevated privilege, we
# need systemd to set that; the older approach of setting something in
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
  String $basedir = '/etc/systemd/system',
  Optional[Variant[Integer,String]] $limitcpu = undef,
  Optional[Variant[Integer,String]] $limitfsize = undef,
  Optional[Variant[Integer,String]] $limitdata = undef,
  Optional[Variant[Integer,String]] $limitstack = undef,
  Optional[Variant[Integer,String]] $limitcore = undef,
  Optional[Variant[Integer,String]] $limitrss = undef,
  Optional[Variant[Integer,String]] $limitnofile = undef,
  Optional[Variant[Integer,String]] $limitas = undef,
  Optional[Variant[Integer,String]] $limitnproc = undef,
  Optional[Variant[Integer,String]] $limitmemlock = undef,
  Optional[Variant[Integer,String]] $limitlocks = undef,
  Optional[Variant[Integer,String]] $limitsigpending = undef,
  Optional[Variant[Integer,String]] $limitmsgqueue = undef,
  Optional[Variant[Integer,String]] $limitnice = undef,
  Optional[Variant[Integer,String]] $limitrtprio = undef,
  Optional[Variant[Integer,String]] $limitrttime = undef,
) {
  #include 'intermapper'

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
    'service_name'    => $service_name,
    'filename'        => $filename,
    'limitcpu'        => $limitcpu,
    'limitfsize'      => $limitfsize,
    'limitdata'       => $limitdata,
    'limitstack'      => $limitstack,
    'limitcore'       => $limitcore,
    'limitrss'        => $limitrss,
    'limitnofile'     => $limitnofile,
    'limitas'         => $limitas,
    'limitnproc'      => $limitnproc,
    'limitmemlock'    => $limitmemlock,
    'limitlocks'      => $limitlocks,
    'limitsigpending' => $limitsigpending,
    'limitmsgqueue'   => $limitmsgqueue,
    'limitnice'       => $limitnice,
    'limitrtprio'     => $limitrtprio,
    'limitrttime'     => $limitrttime,
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

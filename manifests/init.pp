class nginx (
  $user               = $::osfamily ? {
    RedHat                     => 'nginx',
    default                    => 'www-data'
  },
  $worker_processes     = $::processorcount,
  $worker_connections   = 1024,
  $worker_rlimit_nofile = 8192,
  $gzip                 = false
) {

  include nginx::package
  include nginx::config
  include nginx::service

  Class['nginx::package'] -> Class['nginx::config'] ~> Class['nginx::service']

}

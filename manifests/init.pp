class nginx (
  $user               = $::operatingsystem ? {
    /(?i)centos|fedora|redhat/ => "nginx",
    default                    => "www-data",
  },
  $worker_processes   = 1,
  $worker_connections = 1024,
  $gzip               = false
) {

  include nginx::package
  include nginx::config
  include nginx::service

  Class["nginx::package"] -> Class["nginx::config"] ~> Class["nginx::service"]

}

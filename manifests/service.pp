class nginx::service {

  # MAYBE rebuild dynamic configs here?
  # See https://github.com/jfryman/puppet-nginx/blob/master/manifests/service.pp

  service {"nginx":
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
    restart     => "/etc/init.d/nginx reload",
    require     => File["Nginx config"],
  }

}

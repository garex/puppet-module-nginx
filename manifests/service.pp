class nginx::service {

  service {'nginx':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
    restart     => '/etc/init.d/nginx reload',
    require     => File['Nginx config'],
  }

}

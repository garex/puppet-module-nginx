define nginx::proxy (
  $server_name,
  $upstream_name
) {

  file {
    "Nginx configuration file for proxy ${name}":
      path    => "/etc/nginx/conf.d/${name}.proxy.site.conf",
      content => template('nginx/proxy.conf.erb'),
      require => [
        Package['nginx']
      ],
      notify  => Service['nginx'];
  }
}

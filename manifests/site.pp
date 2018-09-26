define nginx::site (
  $server_name,
  $root,
  $is_create_root         = true,
  $ssl_certificate        = undef,
  $ssl_certificate_key    = undef,
  $ssl_listen             = '443',
  $redirect_from_aliases  = undef,
  $root_owner             = undef,
  $root_group             = undef,
  $index                  = 'index.html index.htm',
  $try_files              = '$uri $uri/ $uri.html =404',
  $is_default             = false,
  $is_independent_logs    = false,
  $client_max_body_size   = undef,
  $custom_inside          = undef,
  $is_create_ssl_files    = true,
) {

  $server_name_0 = inline_template('<%= server_name.split(" ")[0] %>')
  if $is_independent_logs {
    $logs_prefix = "${server_name_0}."
  } else {
    $logs_prefix = ''
  }

  if $is_create_root {
    file {
      $root:
        ensure  => directory,
        require => File['Nginx default www directory'],
        recurse => false,
        owner   => $root_owner,
        group   => $root_group;
    }
  }

  file {
    "Nginx root directory for site ${name}":
      ensure  => 'present',
      require => File[$root],
      path    => "/tmp/puppet-module-nginx-site-bug-4867-workaround-${name}";

    "Nginx configuration file for site ${name}":
      path    => "/etc/nginx/conf.d/${name}.site.conf",
      content => template('nginx/site.conf.erb'),
      mode    => 0400,
      owner   => 'root',
      group   => 'root',
      require => [
        File["Nginx root directory for site ${name}"],
        Package['nginx']
      ],
      notify  => Service['nginx'];
  }

  if $ssl_certificate and $is_create_ssl_files {
    file {"Nginx SSL certificate for site ${name}":
      ensure  => 'present',
      path    => "/etc/nginx/ssl/${name}.crt",
      mode    => 0400,
      owner   => 'root',
      group   => 'root',
      source  => $ssl_certificate,
      require => File['Nginx ssl directory should be fresh'],
      notify  => Service['nginx'];
    }
  }

  if $ssl_certificate_key and $is_create_ssl_files {
    file {"Nginx SSL key for site ${name}":
      ensure  => 'present',
      path    => "/etc/nginx/ssl/${name}.key",
      mode    => 0400,
      owner   => 'root',
      group   => 'root',
      source  => $ssl_certificate_key,
      require => File['Nginx ssl directory should be fresh'],
      notify  => Service['nginx'];
    }
  }

  if $custom_inside {
    file {"Nginx custom configuration file for site ${name}":
      ensure  => 'present',
      path    => "/etc/nginx/conf.d/${name}.custom.inside.conf",
      source  => $custom_inside,
      mode    => 0400,
      owner   => 'root',
      group   => 'root',
      require => File["Nginx configuration file for site ${name}"],
      notify  => Service['nginx'];
    }
  }
  # 'Nginx ssl directory should be fresh'

}
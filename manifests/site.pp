define nginx::site (
  $server_name,
  $root,
  $redirect_from_aliases  = undef,
  $root_owner             = undef,
  $root_group             = undef,
  $index                  = 'index.html index.htm',
  $try_files              = '$uri $uri/ $uri.html =404',
  $is_default             = false,
  $is_independent_logs    = false,
  $client_max_body_size   = undef,
  $custom_inside          = undef
) {

  $server_name_0 = inline_template('<%= server_name.split(" ")[0] %>')
  if $is_independent_logs {
    $logs_prefix = "${server_name_0}."
  } else {
    $logs_prefix = ''
  }

  file {
    $root:
      ensure  => directory,
      require => File['Nginx default www directory'],
      recurse => false,
      owner   => $root_owner,
      group   => $root_group;

    "Nginx root directory for site ${name}":
      ensure  => 'present',
      require => File[$root],
      path    => "/tmp/puppet-module-nginx-site-bug-4867-workaround-${name}";

    "Nginx configuration file for site ${name}":
      path    => "/etc/nginx/conf.d/${name}.site.conf",
      content => template('nginx/site.conf.erb'),
      require => [
        File["Nginx root directory for site ${name}"],
        Package['nginx']
      ],
      notify  => Service['nginx'];
  }

  if $custom_inside {
    file {"Nginx custom configuration file for site ${name}":
      ensure  => 'present',
      path    => "/etc/nginx/conf.d/${name}.custom.inside.conf",
      source  => $custom_inside,
      require => File["Nginx configuration file for site ${name}"],
      notify  => Service['nginx'];
    }
  }

}
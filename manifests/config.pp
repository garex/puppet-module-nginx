class nginx::config {

  file {
    'Nginx config':
      require   => Package['nginx'],
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      path      => '/etc/nginx/nginx.conf',
      notify    => Service['nginx'],
      content   => template('nginx/nginx.conf.erb');

    'Nginx default www directory':
      ensure    => directory,
      owner     => 'root',
      group     => 'root',
      path      => '/var/www';

    'Nginx config directory should be fresh':
      ensure    => directory,
      recurse   => true,
      purge     => true,
      path      => '/etc/nginx/conf.d';

    'Nginx sites enabled':
      ensure    => absent,
      path      => '/etc/nginx/sites-enabled',
      recurse   => true,
      force     => true;

    'Nginx sites available':
      ensure    => absent,
      path      => '/etc/nginx/sites-available',
      recurse   => true,
      force     => true;
  }

}
